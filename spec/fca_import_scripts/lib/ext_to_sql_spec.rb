require 'spec_helper'
require 'stringio'
require Rails.root.join('fca_import_scripts', 'lib', 'ext_to_sql')

RSpec.describe ExtToSql do
  describe '#run_over_ext' do
    let(:fixture_file) { File.expand_path "spec/fixtures/#{fixture_name}.ext" }

    subject do
      output_lines = []
      ExtToSql.new.process_ext_file(fixture_file) do |line|
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
        expect(subject[0]).to eq 'COPY lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin;'
        expect(subject[1]).to start_with 'AAA00001	Mr Tab\tSpace	'
        expect(subject[2]).to eq '\.'
      end
    end
  end
end
