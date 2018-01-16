module FCA
  class Row
    HEADER_NAME = 1
    REFERENCE_NUMBER = 0
    NAME = 1
    ADVISER_STATUS_CODE = 4
    FIRM_AUTHORISATION_STATUS_CODE = 19
    SUBSIDIARY_END_DATE = 4

    ACTIVE_FIRM_AUTHORISATION_STATUS_CODES = [
      'Authorised',
      'Registered',
      'EEA Authorised'
    ].freeze

    attr_reader :line, :repairs, :row, :trading_names, :delimeter, :prefix
    def initialize(line, options = {})
      @line          = line.strip
      @delimeter     = options[:delimeter] || '|'
      @prefix        = options[:prefix]
      @trading_names = Set.new
      @repairs       = YAML.load_file(::File.join(Rails.root, 'lib/fca/repairs.yml'))['repairs']
      @row           = repair.force_encoding('ISO-8859-1').split(options[:delimeter])
    end

    def header?
      row.first == 'Header'
    end

    def footer?
      row.first == 'Footer'
    end

    def query
      q = Query.find(row[HEADER_NAME], delimeter: delimeter, prefix: prefix)
      yield Query.headers.join(', ') if q.nil? && block_given?
      q
    end

    def active?(table)
      case table
      when :lookup_advisers
        active_adviser?
      when :lookup_firms
        active_firm?
      when :lookup_subsidiaries
        active_subsidiary?
      else
        raise "Could not determine '#{query.table}' status for line: '#{line}'"
      end
    end

    private

    def active_adviser?
      row[ADVISER_STATUS_CODE] == '4'
    end

    def active_firm?
      ACTIVE_FIRM_AUTHORISATION_STATUS_CODES.include?(row[FIRM_AUTHORISATION_STATUS_CODE])
    end

    def active_subsidiary?
      row[SUBSIDIARY_END_DATE].empty? && unique_trading_name?
    end

    def unique_trading_name?
      trading_names.add?("#{row[REFERENCE_NUMBER]}|#{row[NAME]}")
    end

    def repair
      match = repairs.find { |pair| pair['line'] == line }
      if match.nil?
        logger.warn(name) { "Possibly malformed row detected: #{line}" } if line.include? '""'
        line
      else
        match['replacement']
      end
    end
  end
end
