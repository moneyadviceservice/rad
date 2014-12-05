RSpec.describe Import::Importer do
  Mapper = Class.new do
    def self.call(r)
      r
    end
  end

  let(:csv_opts) { {} }
  let(:csv_path) { Rails.root.join('spec', 'fixtures', 'firms.ext') }
  let(:mapper) { Mapper }

  subject do
    described_class.new(csv_path, mapper, csv_opts)
  end

  describe 'configuration' do
    describe 'mapper configuration' do
      let(:mapper) { ->(r) { @counter += 1 } }

      it 'supports proc semantics' do
        @counter = 0

        expect { subject.import }.to change { @counter }.by(1)
      end
    end

    describe 'CSV options configuration' do
      let(:expected_column_length) { 25 }

      context 'when `csv_opts` is not provided' do
        it 'defaults to | separator' do
          expect(subject.import.first.length).to eq(expected_column_length)
        end
      end

      context 'when `csv_opts` are provided' do
        let(:csv_opts) { { col_sep: ',' } }

        it 'honours the provided options' do
          expect(subject.import.first.length).to eq(1)
        end
      end
    end
  end

  describe '#import' do
    context 'when headers are present' do
      it 'does not map over the headers' do
        expect(mapper).to receive(:call).once

        subject.import
      end
    end
  end
end
