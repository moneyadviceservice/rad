RSpec.describe River::Core do
  let(:filename) { '20160901a.zip' }
  let(:source)   { River.source(filename) }
  let(:content)  do
    <<EOF
This is a simple test file
Not much in it here :)
EOF
  end

  before(:all) { Cloud::Storage.setup }
  after(:all)  { Cloud::Storage.teardown }

  before { Cloud::Storage.upload(filename, content) }
  after  { source.reader.close unless source.reader.closed? }

  describe '.source' do
    it 'returns itself' do
      expect(source).to be_a(River::Core)
    end

    it 'instanciates a reader to specified filename' do
      expect(source.reader).to be_present
    end
  end

  describe '.step' do
    let(:upcase) { ->(s, c) { c.write(s.read.upcase) } }

    it 'runs given block' do
      source.step(&upcase)
      expect(source.reader.read.chop).to eq(content.upcase)
    end
  end

  describe '.sink' do
    let(:db)   { spy('db connection') }
    let(:sql)  { 'select * from fake_table; ' }
    let(:db_conn) { ->(_) { db } }
    let(:load_sql_only_once) do
      lambda do  |_, c|
        if c[:done].blank?
          c.write(sql)
          c[:done] = :done
        end
      end
    end

    it 'closes reader' do
      source.sink(&db_conn)
      expect(source.reader).to be_closed
    end

    it 'executes sql provided by reader' do
      source.step(&load_sql_only_once).sink(&db_conn)
      expect(db).to have_received(:execute).with(sql)
    end
  end
end
