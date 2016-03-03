require 'spec_helper'
require 'stringio'
require Rails.root.join('fca_import_scripts', 'lib', 'ext_to_sql')

RSpec.describe ExtToSql do
  describe '#run_over_ext' do
    let(:fixture_file) { File.expand_path "spec/fixtures/#{fixture_name}.ext" }
    let(:stderr) { StringIO.new }
    let(:instance) { ExtToSql.new(stderr) }

    subject do
      output_lines = []
      instance.process_ext_file(fixture_file) do |line|
        output_lines << line
      end
      output_lines
    end

    context 'advisers file' do
      let(:fixture_name) { 'advisers' }

      it 'generates the right SQL' do
        expect(subject[0]).to eq 'COPY lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin;'
        expect(subject[1]).to start_with 'AAA00001	Mr Alaba Adewale Adebajo	'
        expect(subject[2]).to start_with 'AAA00002	Mr Andy Ademola Adewale	'
        expect(subject[3]).to eq '\.'
      end
    end

    context 'firms file' do
      let(:fixture_name) { 'firms' }

      it 'generates the right SQL' do
        expect(subject[0]).to eq 'COPY lookup_firms (fca_number, registered_name, created_at, updated_at) FROM stdin;'
        expect(subject[1]).to start_with '100013	Skipton Financial Services Ltd	'
        expect(subject[2]).to eq '\.'
      end
    end

    context 'subsidiaries file' do
      let(:fixture_name) { 'firm_names' }

      it 'generates the right SQL' do
        expect(subject[0]).to eq 'COPY lookup_subsidiaries (fca_number, name, created_at, updated_at) FROM stdin;'
        expect(subject[1]).to start_with '100013	Medical Insurance Agency (MIA)	'
        expect(subject[2]).to start_with '100013	NAHT Personal Financial Services	'
        expect(subject[3]).to start_with '100013	SFS Invest Direct	'
        expect(subject[4]).to eq '\.'
      end
    end

    context 'advisers file with a tab key in it' do
      let(:fixture_name) { 'advisers_with_tab' }

      it 'generates the right SQL' do
        expect(subject[1]).to start_with 'AAA00001	Mr\t"Tab"\tSpace	'
        expect(subject[2]).to eq '\.'
      end
    end

    context 'advisers file with broken row' do
      let(:fixture_name) { 'advisers_with_broken_row' }

      it 'warns of a broken row' do
        subject
        expect(stderr.string).to include 'Possibly malformed row detected'
      end

      context 'when there is a stored repair' do
        before do
          stub_const('ExtToSql::REPAIR_FILE', Rails.root.join('spec', 'fixtures', 'repairs.yml'))
        end

        it 'repairs the row' do
          expect(subject[1]).to start_with 'AAA00001	Mr Fixed Adewale Adebajo	'
          expect(subject[2]).to eq '\.'
        end
      end
    end

    context 'advisers file with inactive row' do
      let(:fixture_name) { 'advisers_with_inactive_row' }

      it 'generates the right SQL' do
        expect(subject[1]).to start_with 'AAA00002	Mr Andy Ademola Adewale	'
        expect(subject[2]).to eq '\.'
      end
    end

    context 'firms file with inactive row' do
      let(:fixture_name) { 'firms_with_inactive_row' }

      it 'generates the right SQL' do
        expect(subject[1]).to start_with '100013	Skipton Financial Services Ltd	'
        expect(subject[2]).to start_with '100038	Crane & Partners	'
        expect(subject[3]).to start_with '100039	Crawfords	'
        expect(subject[4]).to eq '\.'
      end
    end

    context 'subsidiaries file with out of date records' do
      let(:fixture_name) { 'firm_names_with_end_dates' }

      it 'filters out any rows with an End Date' do
        expect(subject[0]).to eq 'COPY lookup_subsidiaries (fca_number, name, created_at, updated_at) FROM stdin;'
        expect(subject[1]).to start_with "100013\tMedical Insurance Agency (MIA)\t"
        expect(subject[2]).to start_with "100013\tSFS Invest Direct\t"
        expect(subject[3]).to eq '\.'
      end
    end

    # There is a small amount of records (10 ish) that don't follow the format
    # and are missing end date markers for more than 1 entry for the same name
    context 'subsidiaries file with duplicate entries and no end dates' do
      let(:fixture_name) { 'firm_names_with_end_dates_with_duplicates' }

      it 'filters out any duplicate rows without end dates' do
        expect(subject[0]).to eq 'COPY lookup_subsidiaries (fca_number, name, created_at, updated_at) FROM stdin;'
        expect(subject[1]).to start_with "100013\tMedical Insurance Agency (MIA)\t"
        expect(subject[2]).to start_with "100013\tSFS Invest Direct\t"
        expect(subject[3]).to eq '\.'
      end
    end
  end
end
