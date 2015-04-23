require 'csv'
require 'date'

module ExtToSql
  TIMESTAMP = DateTime.now.strftime('%Y-%m-%d %H:%M:%S.%N')

  module CLI
    def self.print_usage
      puts "USAGE: "
      puts "  ruby ext_to_sql.rb FILE"
      exit
    end

    def self.options
      print_usage unless ARGV.length == 1
      {
        file: ARGV[0]
      }
    end

    def self.write_progress
      @i = 0 if @i.nil?
      if (@i += 1) % 10_000 == 0
        print_to_stderr_and_flush '.'
      end
    end

    def self.print_to_stderr_and_flush(str)
      STDERR.print str
      STDERR.flush
    end
  end

  def self.determine_type_from_header(row)
    case row[1]
    when 'Alternative Firm Name'
      return :subsidiary
    when 'Firm Authorisation'
      return :firm
    when 'Individual Details'
      return :adviser
    else
      STDERR.puts "Unable to determine file type from header: #{row[1]}"
      exit 1
    end
  end

  def self.build_copy_statement_for_type(type)
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

  def self.escape(str)
    str.inspect[1...-1]
  end

  def self.build_row(row)
    number = row[0] # reference number for advisers or firms
    name = escape(row[1].strip)

    "#{number}\t#{name}\t#{TIMESTAMP}\t#{TIMESTAMP}"
  end

  def self.end_copy_statement
    '\.'
  end
end
