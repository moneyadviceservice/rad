require 'csv'
require 'date'

class ExtToSql
  TIMESTAMP = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')

  def initialize(stderr = nil)
    @stderr = stderr
  end

  def process_ext_file(path, &block)
    CSV.foreach(path, col_sep: '|') do |row|
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
