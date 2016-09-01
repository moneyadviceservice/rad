module FCA
  class Import
    class << self
      def call(files, logger = FCA::Config.logger)
        logger.debug(name) { 'Starting FCA data import' }
        start_time = Time.zone.now
        outcome = new(files, logger).call
        logger.info(name) { "Duration: #{Time.zone.now - start_time} seconds" }

        if block_given?
          logger.debug(name) { 'Running callback' }
          cb_outcome = yield(outcome, logger)
          logger.info(name) { "Callback outcome: #{cb_outcome}" }
        end

        logger.close
        outcome
      end

      private

      def name
        'FCA::Import'
      end
    end

    attr_reader :files, :logger

    def initialize(files, logger)
      @files = files
      @logger = logger
    end

    def call
      files.map do |file|
        # River.source(file)
        #   .step(&unzip)
        #   .step(&ext_to_sql)
        #   .sink(&db_connection)
      end
      #   .map do |outcome|
      #     (success?(outcome) ? compute_diff(outcome) : outcome)
      # end
    end

    private

    def unzip
      ->(data, ctx) {}
    end

    def ext_to_sql
      ->(data, ctx) {}
    end

    def db_connection
      ->(ctx) { ActiveRecord::Base.connection }
    end

    def success?(import_result)
      import_result[:error].blank?
    end

    def compute_diff(import_result)
      # per table
    end
  end
end
