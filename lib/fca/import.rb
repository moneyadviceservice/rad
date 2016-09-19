$LOAD_PATH.unshift(File.join(Rails.root, 'lib'))
require 'river'

module FCA
  class Import
    class << self
      def call(files, db, name = 'FCA::Import', logger = FCA::Config.logger)
        logger.info(name) { 'Starting FCA data import' }
        start_time = Time.zone.now
        outcomes = new(files, db, logger).import_all
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
    def initialize(files, db, logger)
      @files   = files
      @logger  = logger
      @context = { logger: @logger, pg: db }
    end

    def import_all
      result = files.map { |file| import(file) }
      if import_successful?(result)
        logger.info('FCA import') { 'files imported successfully' }
        FcaImport.create(
          files:     files.join('|'),
          confirmed: false,
          result:    result.map(&:to_s).join('|'))

      else
        logger.info('FCA import') { 'import failed' }
      end
      result
    end

    def import(file)
      outcomes = River.source(context)
                 .step(&download(file))
                 .step(&unzip(/^firms2\d+\.ext$/, /^indiv_apprvd2\d+\.ext$/, /^firm_names2\d+\.ext$/))
                 .step(&to_sql('fcaimport'))
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
