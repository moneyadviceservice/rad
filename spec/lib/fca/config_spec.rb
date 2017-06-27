RSpec.describe FCA::Config do
  let(:fca_config) do
    FCA::Config.new.tap do |c|
      c.log_level = level
      c.log_file  = file
      c.notify    = slack
      c.hostname  = 'mas.com'
      c.email_recipients = emails
    end
  end
  let(:slack) { { slack: { channel: '#test' } } }

  describe 'FCA::Config.configure' do
    let(:file)  { '/tmp/fca_import.log' }
    let(:level) { :debug }
    let(:emails) { 'user@email.com, foo@email.org.uk' }

    it 'saves `log_file` configuration' do
      expect(fca_config.log_file).to eq file
    end

    it 'saves `log_level` configuration' do
      expect(fca_config.log_level).to eq Logger::DEBUG
    end

    it 'saves `notify` details' do
      expect(fca_config.notify).to eq slack
    end

    it 'returns a logger instance' do
      expect(fca_config.logger).to be_a(Logger)
    end

    it 'returns array of emails' do
      expect(fca_config.email_recipients).to match_array %w[user@email.com foo@email.org.uk]
    end

    context 'default configuration' do
      let(:file)  { nil }
      let(:level) { nil }

      it 'log_file defaults to `STDOUT`' do
        expect(fca_config.log_file).to eq STDOUT
      end

      it 'log_level defaults to `INFO`' do
        expect(fca_config.log_level).to eq Logger::INFO
      end
    end
  end

  describe 'FCA::Config.logger' do
    it 'returns a logger instance' do
      expect(FCA::Config.logger).to be_a(Logger)
    end
  end
end
