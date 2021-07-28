module FCA
  class Query
    TABLES = { # keys to this hash works on header line; row field index 1
      'Approved Individual Details' => :lookup_advisers,
      'Firm Authorisation'          => :lookup_firms,
      'Alternative Firm Name' => :lookup_subsidiaries
    }.freeze

    SCHEMA = {
      lookup_advisers: {
        reference_number:  'char(20) NOT NULL,',
        name:              'varchar(255) NOT NULL,',
        created_at:        'timestamp NOT NULL,',
        updated_at:        'timestamp NOT NULL'
      },
      lookup_firms:   {
        fca_number:        'integer NOT NULL,',
        registered_name:   'varchar(255) NOT NULL DEFAULT \'\',',
        created_at:        'timestamp NOT NULL,',
        updated_at:        'timestamp NOT NULL'
      },
      lookup_subsidiaries: {
        fca_number:        'integer NOT NULL,',
        name:              'varchar(255) NOT NULL DEFAULT \'\',',
        created_at:        'timestamp NOT NULL,',
        updated_at:        'timestamp NOT NULL'
      }
    }.freeze

    class << self
      def find(s, options = {})
        new(options.merge(table: TABLES[s])) if TABLES[s]
      end

      def all
        TABLES.values
      end

      def headers
        TABLES.keys
      end
    end

    attr_reader :table, :delimeter, :timestamp, :options
    def initialize(options = {})
      @options   = options
      @table     = [options[:prefix], options[:table]].join('_')
      @delimeter = options[:delimeter] || '|'
      @timestamp = "'#{Time.now.strftime('%Y-%m-%d %H:%M:%S.%N')}'" # rubocop:disable Rails/TimeZone
      freeze
    end

    def begin
      "BEGIN;\n"
    end

    def commit
      "COMMIT;\n"
    end

    def create_if_not_exists
      <<EOF.strip_heredoc
        DROP SEQUENCE IF EXISTS #{table}_id_seq CASCADE;
        CREATE SEQUENCE #{table}_id_seq;
        DROP TABLE IF EXISTS #{table};
        CREATE TABLE IF NOT EXISTS #{table} (id integer PRIMARY KEY DEFAULT nextval('#{table}_id_seq'), #{columns_definition} );
EOF
    end

    def rename
      [
        "DROP TABLE IF EXISTS last_week_#{options[:table]};\n",
        rename_table(options[:table], "last_week_#{options[:table]}"),
        rename_table(table, options[:table])
      ].join('')
    end

    def rename_table(from, to)
      "ALTER TABLE #{from} RENAME TO #{to};\n"
    end

    def truncate
      "TRUNCATE #{table};\n"
    end

    def copy_statement
      "COPY #{table} (#{columns_name}) FROM stdin CSV DELIMITER '|';\n"
    end

    def values(row)
      "#{vals(row.row)}\n" if row.active?(options[:table])
    end

    private

    def col_print(sep = "\n")
      ->(e) { "#{e}#{sep}" }
    end

    def columns
      SCHEMA.fetch(options[:table]) { raise "Could not found table definition for `#{options[:table]}`" }
    end

    def columns_definition
      columns
        .map { |name, definition| "#{name}  #{definition}" }
        .map(&col_print(' '))
        .join('')
        .chop
    end

    def columns_name
      columns.keys.map(&:to_s).join(', ')
    end

    def number(row)
      table == :lookup_advisers ? "'#{row[Row::REFERENCE_NUMBER_INDEX]}'" : row[Row::REFERENCE_NUMBER_INDEX]
    end

    def escape(str)
      str.gsub('""', '')
    end

    def vals(row)
      [
        number(row),
        escape(row[Row::NAME_INDEX].strip), # name
        timestamp,
        timestamp
      ].join(delimeter)
    end
  end
end
