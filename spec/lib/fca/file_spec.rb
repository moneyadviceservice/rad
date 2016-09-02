RSpec.describe FCA::File do
  describe 'FCA::File.open' do
    let(:stream)   { fixture("#{target}.ext") }
    let(:data)     { StringIO.new }
    let(:sql)      { fixture("#{target}.sql").read }
    let(:log_file) { StringIO.new }
    let(:logger)   { Logger.new(log_file) }

    before { Timecop.freeze(Time.zone.local(1990)) }
    after  { Timecop.return }

    describe '.open' do
      before { FCA::File.open(stream, logger) { |io| data.puts(io.read) } }
      subject { data.string }

      let(:target) { 'complete' }
      it { is_expected.to eq sql }      
    end

    describe '.to_sql' do
      before { FCA::File.new(stream, logger).to_sql(blk) }
      let(:blk) { ->(io) { data.puts(io.read) } }
      subject { data.string }

      let(:target) { 'complete' }
      it { is_expected.to eq sql }
    end

    describe '.to_sql_data' do
      before { FCA::File.new(stream, logger).send(:to_sql_data, blk) }
      let(:blk) { ->(io) { data.puts(io.read) } }
      subject { data.string }

      describe 'special token' do
        context 'unzipped file name token' do
          let(:target) { 'filename_token' }
          it { is_expected.to eq sql }
          it 'logs file name' do
            expect(log_file.string).to include('converting file {{foo.ext}} to sql')
          end
        end
      end

      describe 'converts advisers' do
        context 'when file is well formatted' do
          let(:target) { 'advisers' }
          it { is_expected.to eq sql }
        end

        context 'when file has broken row' do
          let(:target) { 'advisers_with_broken_row' }
          it { is_expected.to eq sql }

          it 'logs a warning' do
            expect(log_file.string).to include 'Possibly malformed row detected: '
          end
        end

        context 'when file has inactive rows' do
          let(:target) { 'advisers_with_inactive_row' }
          it { is_expected.to eq sql }
        end
      end

      describe 'converts firms' do
        context 'when file is well formatted' do
          let(:target) { 'firms' }
          it { is_expected.to eq sql }
        end

        context 'when file has inactive rows' do
          let(:target) { 'firms_with_inactive_row' }
          it { is_expected.to eq sql }
        end
      end

      describe 'converts subsidiaries' do
        context 'when file is well formatted' do
          let(:target) { 'firm_names' }
          it { is_expected.to eq sql }
        end

        context 'when file has records with no end date' do
          let(:target) { 'firm_names_with_end_dates' }
          it { is_expected.to eq sql }
        end

        context 'when file has duplicate entries and records with no end date' do
          let(:target) { 'firm_names_with_end_dates_with_duplicates' }
          it { is_expected.to eq sql }
        end
      end
    end
  end
end
