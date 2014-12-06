require 'csv'

module Import
  class Importer
    def initialize(csv_path, mapper, csv_opts = {})
      @csv_path = csv_path
      @mapper   = mapper
      @csv_opts = { col_sep: '|' }.merge(csv_opts)
    end

    def import
      rows_excluding_headers.map(&mapper)
    end

    protected

    def mapper
      @mapper.method(:call)
    end

    def rows_excluding_headers
      CSV.open(csv_path, csv_opts).tap(&:shift)
    end

    attr_reader :csv_path, :csv_opts
  end
end
