require 'spec_helper'
require 'stringio'
# require Rails.root.join('fca_import_scripts', 'lib', 'ext_to_sql')

RSpec.describe ExtToSql do
  describe '#process_ext_file_content' do
    let(:fixture_content) do
      File.open(File.expand_path("spec/fixtures/#{fixture_name}.ext"), 'rb').read
    end
    let(:stderr) { StringIO.new }
    let(:instance) { ExtToSql.new(fixture_content) }

    let(:prefix_sql) { instance.prefix_sql }

    let(:content_data) do
      output_lines = []
      instance.process_ext_file_content do |line|
        output_lines << line
      end
      output_lines
    end

    context 'advisers file' do
      let(:fixture_name) { 'advisers' }

      it 'generates the right truncate and copy sql' do
        truncate = 'TRUNCATE lookup_import_advisers;'
        copy = 'COPY lookup_import_advisers (reference_number, name, created_at, updated_at) FROM stdin;'
        expect(prefix_sql).to eq(truncate + copy)
      end

      it 'generates the right SQL' do
        expect(content_data[0]).to start_with 'AAA00001	Mr Alaba Adewale Adebajo	'
        expect(content_data[1]).to start_with 'AAA00002	Mr Andy Ademola Adewale	'
      end
    end

    context 'firms file' do
      let(:fixture_name) { 'firms' }

      it 'generates the right truncate and copy sql' do
        truncate = 'TRUNCATE lookup_import_firms;'
        copy = 'COPY lookup_import_firms (fca_number, registered_name, created_at, updated_at) FROM stdin;'
        expect(prefix_sql).to eq(truncate + copy)
      end

      it 'generates the right SQL' do
        expect(content_data[0]).to start_with '100013	Skipton Financial Services Ltd	'
      end
    end

    context 'subsidiaries file' do
      let(:fixture_name) { 'firm_names' }

      it 'generates the right truncate and copy sql' do
        truncate = 'TRUNCATE lookup_import_subsidiaries;'
        copy = 'COPY lookup_import_subsidiaries (fca_number, name, created_at, updated_at) FROM stdin;'
        expect(prefix_sql).to eq(truncate + copy)
      end

      it 'generates the right SQL' do
        expect(content_data[0]).to start_with '100013	Medical Insurance Agency (MIA)	'
        expect(content_data[1]).to start_with '100013	NAHT Personal Financial Services	'
        expect(content_data[2]).to start_with '100013	SFS Invest Direct	'
      end
    end

    context 'advisers file with a tab key in it' do
      let(:fixture_name) { 'advisers_with_tab' }

      it 'generates the right SQL' do
        expect(content_data[0]).to start_with 'AAA00001	Mr\t"Tab"\tSpace	'
      end
    end

    context 'advisers file with broken row' do
      let(:fixture_name) { 'advisers_with_broken_row' }

      it 'warns of a broken row' do
        line = 'Possibly malformed row detected: ' \
                "AAA00001|Mr \"\"Alaba Adewale Adebajo|||4|ADEBAJOALABAADEWALE|20110426|\n"
        expect(Rails.logger).to receive(:error).with(line)
        content_data
      end

      context 'when there is a stored repair' do
        before do
          stub_const('ExtToSql::REPAIR_FILE', Rails.root.join('spec', 'fixtures', 'repairs.yml'))
        end

        it 'repairs the row' do
          expect(content_data[0]).to start_with 'AAA00001	Mr Fixed Adewale Adebajo	'
        end
      end
    end

    context 'advisers file with inactive row' do
      let(:fixture_name) { 'advisers_with_inactive_row' }

      it 'generates the right SQL' do
        expect(content_data[0]).to start_with 'AAA00002	Mr Andy Ademola Adewale	'
      end
    end

    context 'firms file with inactive row' do
      let(:fixture_name) { 'firms_with_inactive_row' }

      it 'generates the right SQL' do
        expect(content_data[0]).to start_with '100013	Skipton Financial Services Ltd	'
        expect(content_data[1]).to start_with '100038	Crane & Partners	'
        expect(content_data[2]).to start_with '100039	Crawfords	'
      end
    end

    context 'subsidiaries file with out of date records' do
      let(:fixture_name) { 'firm_names_with_end_dates' }

      it 'filters out any rows with an End Date' do
        expect(content_data[0]).to start_with "100013\tMedical Insurance Agency (MIA)\t"
        expect(content_data[1]).to start_with "100013\tSFS Invest Direct\t"
      end
    end

    # There is a small amount of records (10 ish) that don't follow the format
    # and are missing end date markers for more than 1 entry for the same name
    context 'subsidiaries file with duplicate entries and no end dates' do
      let(:fixture_name) { 'firm_names_with_end_dates_with_duplicates' }

      it 'filters out any duplicate rows without end dates' do
        expect(content_data[0]).to start_with "100013\tMedical Insurance Agency (MIA)\t"
        expect(content_data[1]).to start_with "100013\tSFS Invest Direct\t"
      end
    end

    context 'not recognised file header' do
      let(:fixture_content) do
        <<-FILE_CONTENT
Header|Made up|20141120|2243|
FILE_CONTENT
      end

      it 'raises an error' do
        expected_error = 'Unable to determine file type from header: Made up'
        begin
          ExtToSql.new(fixture_content)
        rescue RuntimeError => e
          expect(e.message).to eql(expected_error)
        end
      end
    end
  end
end
