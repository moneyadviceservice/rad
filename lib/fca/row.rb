module FCA
  class Row
    HEADER_NAME_INDEX = 1
    REFERENCE_NUMBER_INDEX = 0
    NAME_INDEX = 1

    ADVISER_STATUS_INDEX = 2
    ADVISER_APPROVED_STATUSES =  ['Approved by regulator', 'Regulatory approval no longer required'].freeze

    FIRM_AUTHORISATION_STATUS_INDEX = 14
    FIRM_APPROVED_STATUSES = [
      'Authorised',
      'Registered',
      'EEA Authorised'
    ].freeze

    SUBSIDIARY_END_DATE_INDEX = 4

    attr_reader :line, :repairs, :row, :trading_names, :delimeter, :prefix
    def initialize(line, options = {})
      @line          = line.strip
      @delimeter     = options[:delimeter] || '|'
      @prefix        = options[:prefix]
      @trading_names = Set.new
      @repairs       = YAML.load_file(::File.join(Rails.root, 'lib/fca/repairs.yml'))['repairs']
      @row           = repair.split(options[:delimeter])
    end

    def header?
      row.first == 'Header'
    end

    def footer?
      row.first == 'Footer'
    end

    def query
      q = Query.find(row[HEADER_NAME_INDEX], delimeter: delimeter, prefix: prefix)
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
      ADVISER_APPROVED_STATUSES.include?(row[ADVISER_STATUS_INDEX])
    end

    def active_firm?
      FIRM_APPROVED_STATUSES.include?(row[FIRM_AUTHORISATION_STATUS_INDEX])
    end

    def active_subsidiary?
      row[SUBSIDIARY_END_DATE_INDEX].empty? && unique_trading_name?
    end

    def unique_trading_name?
      trading_names.add?("#{row[REFERENCE_NUMBER_INDEX]}|#{row[NAME_INDEX]}")
    end

    def repair
      # TODO: this is obviously terrible and needs replacing. This is a
      # temporary fix for the firms master list entry with ID 847616. It
      # contains an unterminated quote which breaks the Postgres import.
      #
      # The FCA take a very long time to correct the source data. We need to
      # either change how Postgres handles unterminated quotes when writing to
      # a table or overhaul the repair functionality. Currently line repairs
      # are invalidated with every new set of import files because a timestamp
      # on each line changes every week.
      if line.include?(%(BROKER INS " LTD))
        line.gsub!(%r(BROKER INS " LTD), '')
      end

      line.gsub!('"', '') if line.count('"') == 1

      match = repairs.find { |pair| pair['line'] == line }

      if match.nil?
        line
      else
        match['replacement']
      end
    end
  end
end
