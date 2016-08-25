require 'webmock/rspec'

RSpec.describe Cloud::Providers::Azure do
  subject { Cloud::Providers::Azure.new(settings) }

  let(:container_name) { 'fca-imports' }
  let(:settings) do
    {
      container_name: container_name,
      account_name: 'masassets',
      shared_key: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA6MMjecSV6i0zm5lLsZejQbNGpW3+YHKOVRaJyhnUsjjCU1fw6t7ciOg=='
    }
  end

  before do
    stub_request(:get, 'https://masassets.blob.core.windows.net/?comp=list')
    allow(subject).to receive(:container).and_return(double(:container, name: 'fca-imports'))
  end

  describe '.list' do
    it 'invokes `list_blobs`' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:list_blobs).with(container_name)

      subject.list
    end
  end

  describe '.download' do
    it 'invokes `get_blob`' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:get_blob).with(container_name,'file_to_download.txt')

      subject.download('file_to_download.txt')
    end
  end

  describe '.move' do
    it 'invokes `copy_blob`' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService)
        .to receive(:copy_blob).with(container_name,'incoming/file_to_import.txt',
                                     container_name, 'archives/file.txt')

      subject.move('incoming/file_to_import.txt', 'archives/file.txt')
    end
  end
end
