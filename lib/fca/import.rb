$LOAD_PATH.unshift(File.join(Rails.root, 'lib'))
require 'river'

module FCA
  class Import
    LOOKUP_TABLE_PREFIX = 'fcaimport'

    class << self
      def call(files, context, name = 'FCA::Import', logger = FCA::Config.logger)
        logger.info(name) { 'Starting FCA data import' }
        start_time = Time.zone.now
        outcomes = new(files, context, logger).import_all
        logger.info(name) { "Duration: #{Time.zone.now - start_time} seconds" }

        if block_given?
          logger.debug(name) { 'Running callback' }
          cb_outcome = yield(outcomes)
          logger.info(name) { "Callback outcome: #{cb_outcome}" }
        end

        outcomes
      end
    end

    include Utils

    attr_reader :files, :logger, :context
    def initialize(files, context, logger)
      @files   = files
      @logger  = logger
      @context = context.merge(logger: @logger)
    end

    def import_all
      result = files.map { |file| import(file) }
      if import_successful?(result)
        logger.info('FCA import') { 'files imported successfully' }
      else
        logger.info('FCA import') { 'import failed' }
      end
      context[:model].update_columns(
        result: result.map(&:to_s).join('|'),
        status: 'processed'
      )
      result
    end

    def import(file)
      outcomes = River.source(context)
                 .step(&download(file))
                 .step(&unzip(/^firms_master_list2\d+\.ext$/, /^indiv_apprvd2\d+\.ext$/, /^firm_names2\d+\.ext$/))
                 .step(&to_sql(LOOKUP_TABLE_PREFIX))
                 .step(&save)
                 .sink

      import_status = outcomes.map(&:success?).all?
      if import_status
        logger.info("Import #{file}") { 'processed successfully' }
      else
        logger.info("Import #{file}") { "import error #{outcomes.compact.map(&:result)}" }
      end

      [file, import_status, outcomes]
    end
  end
end
