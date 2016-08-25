RSpec.describe Cloud::Storage do

  describe '.new' do
    context 'when using local provider' do
      subject { Cloud::Storage.new(:local).provider }

      it { is_expected.to be_a(Cloud::Providers::Local) }
    end

    context 'when using azure provider' do
      subject { Cloud::Storage.new(:azure,{}).provider }

      it { is_expected.to be_a(Cloud::Providers::Azure) }
    end

    context 'when using an bad provider name' do
      it 'raises an `ArgumentError`' do
        expect{ Cloud::Storage.new(:bad_name,{}) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.list' do
    subject { Cloud::Storage.new(:azure,{}) }

    it 'delegates to specified provider' do
      expect_any_instance_of(Cloud::Providers::Azure).to receive(:list)
      subject.list
    end
  end


  describe '.download' do
    subject { Cloud::Storage.new(:azure,{}) }

    it 'delegates to specified provider' do
      expect_any_instance_of(Cloud::Providers::Azure).to receive(:download)
      subject.download
    end
  end


  describe '.move' do
    subject { Cloud::Storage.new(:azure,{}) }

    it 'delegates to specified provider' do
      expect_any_instance_of(Cloud::Providers::Azure).to receive(:move)
      subject.move
    end
  end

end
