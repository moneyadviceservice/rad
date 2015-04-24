require 'csv'
require 'date'
require 'yaml'

class ExtToSql
  TIMESTAMP = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')
  REPAIR_FILE = File.join(File.dirname(__FILE__), '..', 'repairs.yml')

  def initialize(stderr = nil)
    @stderr = stderr
  end

  def process_ext_file(path, &block)
    File.foreach(path) do |line|
      line = repair_line line
      row = line.split('|')

      next if row[0] == 'Footer'

      if row[0] == 'Header'
        @type = determine_type_from_header(row)
        block.call build_copy_statement_for_type(@type)
        log "  • \033[33;36mConverting #{@type} EXT to SQL.\033[0m ", newline: false
        next
      end

      block.call build_row(row)
      write_progress
    end

    block.call end_copy_statement
  end

  def determine_type_from_header(row)
    case row[1]
    when 'Alternative Firm Name'
      return :subsidiary
    when 'Firm Authorisation'
      return :firm
    when 'Individual Details'
      return :adviser
    else
      fail "Unable to determine file type from header: #{row[1]}"
    end
  end

  def build_copy_statement_for_type(type)
    case type
    when :adviser
      'COPY lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin;'
    when :firm
      'COPY lookup_firms (fca_number, registered_name, created_at, updated_at) FROM stdin;'
    when :subsidiary
      'COPY lookup_subsidiaries (fca_number, name, created_at, updated_at) FROM stdin;'
    else
      fail
    end
  end

  def build_row(row)
    number = row[0] # reference number for advisers or firms
    name = escape(row[1].strip)

    "#{number}\t#{name}\t#{TIMESTAMP}\t#{TIMESTAMP}"
  end

  def end_copy_statement
    '\.'
  end

  private

  def repairs
    @fixes ||= YAML.load_file(REPAIR_FILE)['repairs']
  end

  def repair_line(line)
    line = line.strip
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
    @i = 0 if @i.nil?
    if (@i += 1) % 10_000 == 0
      log '.', newline: false
    end
  end

  def escape(str)
    str.inspect[1...-1]
  end
end
