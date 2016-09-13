RSpec.describe FCA::Query do
  let(:tables) { FCA::Query::TABLES }
  let(:header)  { 'Alternative Firm Name' }
  let(:options) { { prefix: 'test', delimeter: ',' } }

  describe 'tables mapping' do
    it 'line Header with `Individual Details`' do
      expect(tables['Individual Details']).to eq :lookup_advisers
    end

    it 'line Header with `Firm Authorisation`' do
      expect(tables['Firm Authorisation']).to eq :lookup_firms
    end

    it 'line Header with `Alternative Firm Name`' do
      expect(tables['Alternative Firm Name']).to eq :lookup_subsidiaries
    end
  end

  describe 'Query.find' do
    let(:query)   { FCA::Query.find(header, options) }

    context 'when header valid' do
      it 'returns a query obj' do
        expect(query.class).to be FCA::Query
      end

      it 'sets table name' do
        expect(query.table).to eq ['test', :lookup_subsidiaries].join('_')
      end

      it 'sets file delimeter' do
        expect(query.delimeter).to eq ','
      end

      it 'sets timestamps' do
        expect(query.timestamp).to be_present
      end
    end

    context 'when header is invalid' do
      let(:header) { 'philistine' }
      it 'returns `nil` value' do
        expect(query).to be nil
      end
    end
  end

  describe 'Query.all' do
    it 'returns all defined tables' do
      expect(FCA::Query.all).to eq [:lookup_advisers, :lookup_firms, :lookup_subsidiaries]
    end
  end

  describe 'sql statements' do
    subject     { FCA::Query.new(table: :lookup_advisers, delimeter: '|', prefix: 'test') }
    let(:line)  { ' ' }
    let(:row)   { FCA::Row.new(line, delimeter: '|', table: :lookup_advisers) }

    it '.begin' do
      expect(subject.begin).to eq "BEGIN;\n"
    end

    it '.commit' do
      expect(subject.commit).to eq "COMMIT;\n"
    end

    it '.create_if_not_exists' do
      expect(subject.create_if_not_exists.chop)
        .to eq "DROP SEQUENCE IF EXISTS test_lookup_advisers_id_seq CASCADE;
CREATE SEQUENCE test_lookup_advisers_id_seq;
DROP TABLE IF EXISTS test_lookup_advisers;
CREATE TABLE IF NOT EXISTS test_lookup_advisers (id integer PRIMARY KEY DEFAULT nextval('test_lookup_advisers_id_seq'), reference_number  char(20) NOT NULL, name  varchar(255) NOT NULL, created_at  timestamp NOT NULL, updated_at  timestamp NOT NULL );" # rubocop:disable all
    end

    it '.truncate' do
      expect(subject.truncate).to eq "TRUNCATE test_lookup_advisers;\n"
    end

    it '.copy_statement' do
      expect(subject.copy_statement)
        .to eq "COPY test_lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin CSV DELIMITER '|';\n"
    end

    describe '.values' do
      context 'when row active' do
        let(:line) do
          '100039|Crawfords|23|1|4|Stanton House|41 Blackfriars Road|||Salford|Lancashire|M3|7DB|44|0161|832 5366|44|0161|832 1829|Cancelled|20090521|20011201|CRAWFORDS|20090521|'.force_encoding('ISO-8859-1') # rubocop:disable all
        end

        it '.prints line' do
          expect(subject.values(row)).to include '100039|Crawford'
        end
      end

      context 'when row inactive' do
        let(:line) do
          '100039|Crawfords|23|1|N|Stanton House|41 Blackfriars Road|||Salford|Lancashire|M3|7DB|44|0161|832 5366|44|0161|832 1829|Cancelled|20090521|20011201|CRAWFORDS|20090521|' # rubocop:disable all
        end

        it '.prints line' do
          expect(subject.values(row)).to be_nil
        end
      end
    end

    it '.rename' do
      expect("#{subject.rename}").to eq 'BEGIN;
ALTER TABLE lookup_advisers RENAME TO last_week_lookup_advisers;
ALTER TABLE test_lookup_advisers RENAME TO lookup_advisers;
COMMIT;
'
    end

    it '.rename_table' do
      expect(subject.rename_table(:foo, :bar)).to eq "ALTER TABLE foo RENAME TO bar;\n"
    end
  end
end
