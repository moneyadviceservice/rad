RSpec.describe FCA::Query do
  let(:tables) { FCA::Query::TABLES }
  let(:header)  { 'Alternative Firm Name' }
  let(:options) { { prefix: 'test', delimeter: ',' } }

  describe 'tables mapping' do
    it 'line Header with `Approved Individual Details`' do
      expect(tables['Approved Individual Details']).to eq :lookup_advisers
    end

    it 'line Header with `Firm Authorisation`' do
      expect(tables['Firm Authorisation']).to eq :lookup_firms
    end

    it 'line Header with `Alternative Firm Name`' do
      expect(tables['Alternative Firm Name']).to eq :lookup_subsidiaries
    end
  end

  describe 'Temporay table schema' do
    context 'lookup_subsidiaries' do
      let(:subsidiares) { FCA::Query::SCHEMA[:lookup_subsidiaries] }
      it 'has a schema' do
        expect(subsidiares).to include(fca_number: 'integer NOT NULL,', name: 'varchar(255) NOT NULL DEFAULT \'\',')
      end
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
      expect(FCA::Query.all).to eq %i[lookup_advisers lookup_firms lookup_subsidiaries]
    end
  end

  describe 'sql statements' do
    subject     { FCA::Query.new(table: :lookup_advisers, delimeter: '|', prefix: 'test') }
    let(:line)  { ' ' }

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
CREATE TABLE IF NOT EXISTS test_lookup_advisers (id integer PRIMARY KEY DEFAULT nextval('test_lookup_advisers_id_seq'), reference_number  char(20) NOT NULL, name  varchar(255) NOT NULL, created_at  timestamp NOT NULL, updated_at  timestamp NOT NULL );"
    end

    it '.truncate' do
      expect(subject.truncate).to eq "TRUNCATE test_lookup_advisers;\n"
    end

    it '.copy_statement' do
      expect(subject.copy_statement)
        .to eq "COPY test_lookup_advisers (reference_number, name, created_at, updated_at) FROM stdin CSV DELIMITER '|';\n"
    end

    describe '.values' do
      def new_query(table)
        FCA::Query.new(delimeter: '|', table: table)
      end

      def new_row(line, table)
        FCA::Row.new(line, delimeter: '|', table: table)
      end

      describe 'firms' do
        let(:table) { :lookup_firms }

        let(:query_table) { new_query(table) }

        def line(status)
          "100015|Saffron Building Society|Incorporated under Building Societies Act 1986|Regulated|Not hold and not control client money|Saffron House|1a Market Place|||Saffron Walden|Essex|CB10 1HX|44|01799522211|#{status}|20011201|20010704|SAFFRONBUILDINGSOCIETY|20210511|IP00485B|||"
        end

        allowed = ['Authorised', 'EEA Authorised', 'Registered']

        allowed.each do |status|
          context "approval status: #{status}" do
            it 'should be included in import' do
              line = line(status)

              row = new_row(line, table)

              expect(query_table.values(row)).to include line[0..15]
            end
          end
        end

        disallowed = ['Authorised - Closed to Regulated Bisiness',
                      'No longer registered as an Appointed Representative',
                      'Temporary Registration']

        disallowed.each do |status|
          context "approval status: #{status}" do
            it 'should NOT be included in import' do
              row = new_row(line(status), table)

              expect(query_table.values(row)).to be_nil
            end
          end
        end
      end

      describe 'advisers' do
        let(:table) { :lookup_advisers }

        let(:query_table) { new_query(table) }

        def line(status)
          "AAA00005|Mr Anthony Andrew Apps|#{status}|APPSANTHONYANDREW|20210426|"
        end

        allowed = ['Approved by regulator', 'Regulatory approval no longer required']

        allowed.each do |status|
          context "approval status: #{status}" do
            it 'should be included in import' do
              line = line(status)

              row = new_row(line, table)

              expect(query_table.values(row)).to include line[0..15]
            end
          end
        end

        context 'approval status: Prohibited' do
          it 'should NOT be included in import' do
            row = new_row(line('Prohibited'), table)

            expect(query_table.values(row)).to be_nil
          end
        end
      end

      describe 'subsidiary' do
        let(:table) { :lookup_subsidiaries }

        let(:query_table) { new_query(table) }

        let(:query_header) { new_row('Header|Alternative Firm Name', table).query }

        def line(date: '', name: 'Saffron Insure')
          "100015|#{name}|Trading|20071101|#{date}|SAFFRONINSURE|20200403|"
        end

        context 'has NO End Date' do
          it 'should be included in import' do
            row = new_row(line, table)

            expect(query_table.values(row)).to include line[0..9]
          end
        end

        context 'has an End Date' do
          it 'should NOT be included in import' do
            row = new_row(line(date: '20210403'), table)

            expect(query_table.values(row)).to be_nil
          end
        end

        context 'repeated firms' do
          it 'should NOT be included in import' do
            row = new_row(line, table)

            expect(query_header.values(row)).not_to be_nil

            expect(query_header.values(row)).to be_nil
          end
        end

        context 'unrepeated firms' do
          it 'should be included in import' do
            row = new_row(line(name: 'Saffron Robe'), table)
            query_header.values(row)

            row = new_row(line, table)

            expect(query_table.values(row)).to include line[0..15]
          end
        end
      end
    end

    it '.rename' do
      expect(subject.rename.to_s).to eq 'DROP TABLE IF EXISTS last_week_lookup_advisers;
ALTER TABLE lookup_advisers RENAME TO last_week_lookup_advisers;
ALTER TABLE test_lookup_advisers RENAME TO lookup_advisers;
'
    end

    it '.rename_table' do
      expect(subject.rename_table(:foo, :bar)).to eq "ALTER TABLE foo RENAME TO bar;\n"
    end
  end
end
