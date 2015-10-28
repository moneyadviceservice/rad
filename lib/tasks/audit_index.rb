require 'csv'
require 'pp'
require 'io/console'

module Tasks
  class AuditIndex
    def all_es_firm_ids
      @all_es_firm_ids ||= find_all_es_firm_ids
    end

    def all_pg_firm_ids
      @all_pg_firm_ids ||= find_all_pg_firm_ids
    end

    def in_es_not_pg
      @in_es_not_pg ||= all_es_firm_ids - all_pg_firm_ids
    end

    def in_pg_not_es
      @in_pg_not_es ||= all_pg_firm_ids - all_es_firm_ids
    end

    # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def action(o)
      if o[:publishable?] && o[:geocoded?] && !o[:exists_in_es?]
        :index
      elsif o[:publishable?] && !o[:geocoded?]
        :invalid_firm_address?
      elsif o[:exists_in_es?] && (!o[:exists_in_db?] || !o[:publishable?])
        :delete_from_es
      elsif !o[:exists_in_es?] && !o[:publishable?]
        :do_nothing
      else
        :dunno
      end
    end
    # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def analyse_in_es_not_pg
      @analyse_in_es_not_pg ||= in_es_not_pg.map do |id|
        exists_in_db = Firm.exists?(id)
        firm = Firm.find(id) if exists_in_db
        res = {
          id: id,
          exists_in_es?: true,
          exists_in_db?: exists_in_db,
          publishable?: firm.try(&:publishable?),
          geocoded?: firm.try(&:geocoded?),
          frn: firm.try(&:fca_number),
          name: firm.try(&:registered_name)
        }

        res[:action] = action(res)

        res
      end
    end

    def analyse_in_pg_not_es
      @analyse_in_pg_not_es ||= in_pg_not_es.map do |id|
        firm = Firm.find(id)

        res = {
          id: id,
          exists_in_es?: false,
          exists_in_db?: true,
          publishable?: firm.publishable?,
          geocoded?: firm.geocoded?,
          frn: firm.fca_number,
          name: firm.registered_name
        }

        res[:action] = action(res)

        res
      end
    end

    def by_action(results)
      results.group_by { |result| result[:action] }
    end

    def terminal_col_width
      IO.console.winsize[1]
    end

    def analyse(out = $stdout)
      # Pre-cache so we can see output after SQL logs in Pry
      analyse_in_es_not_pg
      analyse_in_pg_not_es

      out.puts 'In ES not PG:'
      PP.pp(by_action(analyse_in_es_not_pg), out, terminal_col_width)

      out.puts 'In PG not ES:'
      PP.pp(by_action(analyse_in_pg_not_es), out, terminal_col_width)
    end

    def to_csv
      headers = [:id, :frn, :name, :exists_in_es?, :exists_in_db?, :publishable?, :geocoded?, :action]
      CSV.generate do |csv|
        csv << headers

        (analyse_in_es_not_pg + analyse_in_pg_not_es).map do |o|
          csv << headers.map { |key| o[key] }
        end
      end
    end

    def self.analyse
      new.tap(&:analyse)
    end

    def self.to_csv
      new.to_csv
    end

    private

    def find_all_es_firm_ids
      response = ElasticSearchClient.new.search('firms/_search?size=10000&fields=')
      res = JSON.parse(response.body)
      res['hits']['hits'].map do |hit|
        hit['_id']
      end.map(&:to_i).sort.freeze
    end

    def find_all_pg_firm_ids
      Firm.registered.geocoded.pluck(:id).sort.freeze
    end
  end
end
