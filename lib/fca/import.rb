$:.unshift(File.join(Rails.root, 'lib'))
require 'zip'
require 'river'

module FCA
  class Import
    class << self
      def call(files)
        import(files, ActiveRecord::Base.connection_config, 'FCA::Import', FCA::Config.logger)
      end

      def import(files, db_conf, name, logger)
        logger.info(name) { 'Starting FCA data import' }
        start_time = Time.zone.now
        outcome = new(files, db_conf, logger).import_all
        logger.info(name) { "Duration: #{Time.zone.now - start_time} seconds" }

        if block_given?
          logger.debug(name) { 'Running callback' }
          cb_outcome = yield(outcome, logger)
          logger.info(name) { "Callback outcome: #{cb_outcome}" }
        end

        outcome
      end
    end

    attr_reader :files, :db_conf, :logger

    def initialize(files, db_conf, logger)
      @files   = files
      @db_conf = db_conf
      @logger  = logger
    end

    def import_all
      result = files.map { |file| import(file) }
      if import_successful?(result)
        logger.info('FCA import') { 'files imported successfully' }
      else
        logger.info('FCA import') { 'import failed' }
      end
      result
    end

    def import(file)
      outcome = River
                .source(file)
                .step(&unzip_and_convert)
                .sink(&db_configuration)

      if outcome.success?
        logger.info("Import #{file}") { 'imported successfully' }
      else
        logger.info("Import #{file}") { "import error #{outcome.result}" }
      end

      [file, outcome.success?, outcome]
    end

    private

    def unzip_and_convert
      lambda do |stream, context|
        stream.set_encoding('ISO8859-1')
        Zip::InputStream.open(stream) do |io|
          while (entry = io.get_next_entry)
            if ignore_file?(entry.name)
              FCA::Config.logger.info('UNZIP') { "Ignoring file `#{entry.name}`" }
              next
            else
              FCA::Config.logger.info('UNZIP') { "Processing file `#{entry.name}`" }
              FCA::File.open(io, FCA::Config.logger) do |io|
                FCA::Config.logger.debug('TOSQL') { "About to pass line down the pipe" }
                if line = io.gets
                  FCA::Config.logger.debug('TOSQL') { "converted  #{line}" }
                  context.write(line)
                end
              end
            end
          end
        end
      end
    end

    def ignore_file?(filename)
      filename_regexps = {
        lookup_firms:        /^firms2\d+\.ext$/,
        lookup_advisers:     /^indiv_apprvd2\d+\.ext$/,
        lookup_subsidiaries: /^firm_names2\d+\.ext$/
      }
      (filename_regexps.values.map { |r| filename.strip.downcase =~ r }).compact.empty?
    end

    def db_configuration
      lambda do |_|
        {
          host:     db_conf[:host],
          port:     (db_conf[:port] || 5432),
          dbname:   db_conf[:database],
          user:     db_conf[:username],
          password: db_conf[:password],
          connect_timeout: 5
        }
      end
    end

    def import_successful?(outcomes)
      outcomes.map(&:second).reduce(true) { |b, v| !!(b && v) }
    end
  end
end
