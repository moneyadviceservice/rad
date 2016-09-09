require 'date'
require 'set'
require 'yaml'

module FCA
  class File
    class << self
      def open(stream, logger, &blk)
        new(stream, logger).to_sql(blk)
      end
    end

    module COLUMNS
      HEADER_NAME = 1
      REFERENCE_NUMBER = 0
      NAME = 1
      ADVISER_STATUS_CODE = 4
      FIRM_AUTHORISATION_STATUS_CODE = 19
      SUBSIDIARY_END_DATE = 4
    end

    attr_reader :stream, :logger, :name, :trading_names, :target_table

    def initialize(stream, logger)
      @stream = stream
      @logger = logger
      @name   = 'FCAFILE'
      @trading_names = Set.new
    end

    def to_sql(blk)
      stream.each { |line| convert(line, blk) }
    end

    private

    def convert(line, cb)
      row = repair(line).split('|')

      case row.first
      when 'Footer'              # is ignored
        logger.debug(name) { "Ignoring Footer #{line}" }
      when 'Header'              # defines the starts of sql statement
        @target_table = find_target_table(row)
        logger.info(name) { "Target table found: `#{target_table}`" }
        cb.call(sql_copy(target_table))
        logger.debug(name) { 'Adding COPY statement' }

      else
        if record_active?(row)
          cb.call(sql_data(row))
        else
          logger.debug(name) { "Inacitve row detected for row #{row[0..2]}" }
        end
      end
    end

    def repairs
      @fixes ||= YAML.load_file(::File.join(Rails.root, 'lib/fca/repairs.yml'))['repairs']
    end

    def tables
      {
        'Individual Details'    => :lookup_advisers,
        'Firm Authorisation'    => :lookup_firms,
        'Alternative Firm Name' => :lookup_subsidiaries
      }
    end

    def sql_statements
      {
        lookup_advisers:     "TRUNCATE #{table_name(:lookup_advisers)};\nCOPY #{table_name(:lookup_advisers)} (reference_number, name, created_at, updated_at) FROM stdin CSV DELIMITER '|'\n",
        lookup_firms:        "TRUNCATE #{table_name(:lookup_advisers)};\nCOPY #{table_name(:lookup_firms)} (fca_number, registered_name, created_at, updated_at) FROM stdin CSV DELIMITER '|'\n",
        lookup_subsidiaries: "TRUNCATE #{table_name(:lookup_advisers)};\nCOPY #{table_name(:lookup_subsidiaries)} (fca_number, name, created_at, updated_at) FROM stdin CSV DELIMITER '|'\n"
      }
    end

    def row_status_checker
      {
        lookup_advisers:     ->(r) { r[COLUMNS::ADVISER_STATUS_CODE] == '4' },
        lookup_firms:        ->(r) { ['Authorised', 'Registered', 'EEA Authorised'].include?(r[COLUMNS::FIRM_AUTHORISATION_STATUS_CODE]) },
        lookup_subsidiaries: ->(r) { r[COLUMNS::SUBSIDIARY_END_DATE].empty? && unique_trading_name?(r) }
      }
    end

    def find_target_table(row)
      msg = "Unable to determine target table from header: '#{row[COLUMNS::HEADER_NAME]}' in #{tables}"
      tables.fetch(row[COLUMNS::HEADER_NAME]) { log_and_fail(msg) }
    end

    def sql_copy(target)
      msg = "Could not find sql statements for target #{target} in #{sql_statements}"
      StringIO.new(sql_statements.fetch(target) { log_and_fail(msg) })
    end

    def sql_data(row)
      timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S.%N') # rubocop:disable Rails/TimeZone

      fca_number_or_ref_number = (target_table == :lookup_advisers ? "'#{row[COLUMNS::REFERENCE_NUMBER]}'" : row[COLUMNS::REFERENCE_NUMBER])

      vals = [
        fca_number_or_ref_number,
        escape(row[COLUMNS::NAME].strip), # name
        "'#{timestamp}'",
        "'#{timestamp}'"
      ]

      logger.debug(name) { "Active row detected: #{vals[0..2]}" }
      StringIO.new("#{vals.join('|')}\n")
    end

    def record_active?(row)
      msg = "Could not find an status_checker for target '#{target_table}' in #{row_status_checker}"
      (row_status_checker.fetch(target_table) { log_and_fail(msg) }).call(row)
    end

    def escape(str)
      str.gsub('""', '')
    end

    def table_name(table, prefix = 'fcaimport')
      [prefix, table].join('_')
    end

    def repair(line)
      line = line.strip
      match = repairs.find { |pair| pair['line'] == line }
      if match.nil?
        warn_on_possibly_broken_line(line)
      else
        match['replacement']
      end
    end

    def warn_on_possibly_broken_line(line)
      logger.warn(name) { "Possibly malformed row detected: #{line}" } if line.include? '""'
      line
    end

    def log_and_fail(msg)
      logger.fatal(name) { msg }
      fail msg
    end

    def unique_trading_name?(row)
      trading_names.add?("#{row[COLUMNS::REFERENCE_NUMBER]}|#{row[COLUMNS::NAME]}")
    end
  end
end
