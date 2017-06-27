require 'date'
require 'set'
require 'yaml'

# rubocop:disable Metrics/LineLength

class ExtToSql
  TIMESTAMP = Time.now.strftime('%Y-%m-%d %H:%M:%S.%N') # rubocop:disable Rails/TimeZone
  REPAIR_FILE = File.join(File.dirname(__FILE__), '..', 'repairs.yml')

  module COLUMNS
    HEADER_NAME = 1
    REFERENCE_NUMBER = 0
    NAME = 1
    ADVISER_STATUS_CODE = 4
    FIRM_AUTHORISATION_STATUS_CODE = 19
    SUBSIDIARY_END_DATE = 4
  end

  def initialize(stderr = nil)
    @stderr = stderr
    @seen_trading_names = Set.new
  end

  def process_ext_file(path)
    File.foreach(path) do |line|
      line = repair_line line
      row = line.split('|')

      next if row.first == 'Footer'

      if row.first == 'Header'
        @type = determine_type_from_header(row)
        yield build_copy_statement
        log "  • \033[33;36mConverting #{@type} EXT to SQL.\033[0m ", newline: false
        next
      end

      yield build_row(row) if record_active?(row)

      write_progress
    end

    yield end_copy_statement
  end

  private

  def determine_type_from_header(row)
    case row[COLUMNS::HEADER_NAME]
    when 'Individual Details'
      :adviser
    when 'Firm Authorisation', 'Firms Master List'
      :firm
    when 'Alternative Firm Name'
      :subsidiary
    else
      raise "Unable to determine file type from header: #{row[COLUMNS::HEADER_NAME]}"
    end
  end

  def build_copy_statement
    case @type
    when :adviser
      'COPY lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin;'
    when :firm
      'COPY lookup_firms (fca_number, registered_name, created_at, updated_at) FROM stdin;'
    when :subsidiary
      'COPY lookup_subsidiaries (fca_number, name, created_at, updated_at) FROM stdin;'
    end
  end

  def build_row(row)
    number = row[COLUMNS::REFERENCE_NUMBER] # reference number for advisers or firms
    name = escape(row[COLUMNS::NAME].strip)

    "#{number}\t#{name}\t#{TIMESTAMP}\t#{TIMESTAMP}"
  end

  def record_active?(row)
    # For details on this, see FS Register Extract Service on Computer Readable
    # Media Subscriber's Handbook

    case @type
    when :adviser
      row[COLUMNS::ADVISER_STATUS_CODE] == '4' # Value 4 means 'Active'
    when :firm
      # Col 19 - Current Authorisation Status code
      ['Authorised', 'Registered', 'EEA Authorised'].include?(row[COLUMNS::FIRM_AUTHORISATION_STATUS_CODE])
    when :subsidiary
      row[COLUMNS::SUBSIDIARY_END_DATE].empty? && unique_trading_name?(row)
    end
  end

  def repairs
    @fixes ||= YAML.load_file(REPAIR_FILE)['repairs']
  end

  def repair_line(line)
    line = line.strip.mb_chars.tidy_bytes
    match = repairs.find { |pair| line == pair['line'] }
    if match.nil?
      warn_on_possibly_broken_line line
      line
    else
      match['replacement']
    end
  end

  def warn_on_possibly_broken_line(line)
    return unless line.include? '""'
    log "\n  • \033[33;31mPossibly malformed row detected:\033[0m #{line}\n    ", newline: false
  end

  def unique_trading_name?(row)
    # Returns nil if the key already exists. Otherwise returns self.
    @seen_trading_names.add?("#{row[COLUMNS::REFERENCE_NUMBER]}|#{row[COLUMNS::NAME]}")
  end

  def end_copy_statement
    '\.'
  end

  def log(str, newline: true)
    return if @stderr.nil?
    if newline
      @stderr.puts str
    else
      @stderr.print str
      @stderr.flush
    end
  end

  def write_progress
    @i ||= 0
    log '.', newline: false if ((@i += 1) % 10_000).zero?
  end

  def escape(str)
    str.gsub("\t", '\t')
  end
end
