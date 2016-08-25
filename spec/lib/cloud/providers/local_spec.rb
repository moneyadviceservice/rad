RSpec.describe Cloud::Providers::Local do
  subject { Cloud::Providers::Local.new(root: Rails.root) }

  before      { Cloud::Providers::Local.new(root: Rails.root).setup }
  after(:all) { Cloud::Providers::Local.new(root: Rails.root).teardown }

  describe '.upload' do
    it 'create a empty file' do
      subject.upload('foo.txt')
      expect(subject.list).to match_array(['foo.txt'])
    end
  end
end
