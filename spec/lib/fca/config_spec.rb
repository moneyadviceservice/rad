RSpec.describe FCA::Config do
  let(:fca)   { FCA::Config }

  describe 'FCA::Config.configure' do
    let(:file)  { '/var/log/fca_import.log' }
    let(:level) { :debug }
    before do
      fca.configure do |c|
        c.log_file = file
        c.log_level = level
      end
    end

    it 'saves `log_file` configuration' do
      expect(fca.config.log_file).to eq file
    end

    it 'saves `log_level` configuration' do
      expect(fca.config.log_level).to eq Logger::DEBUG
    end

    context 'default configuration' do
      let(:file)  { nil }
      let(:level) { nil }

      it 'log_file defaults to `STDOUT`' do
        expect(fca.config.log_file).to eq STDOUT
      end

      it 'log_level defaults to `INFO`' do
        expect(fca.config.log_level).to eq Logger::INFO
      end
    end
  end

  describe 'FCA::Config.logger' do
    it 'returns a logger instance' do
      expect(FCA::Config.logger).to be_a(Logger)
    end
  end

  describe '.logger' do
    it 'returns a logger instance' do
      expect(fca.config.logger).to be_a(Logger)
    end
  end
end
