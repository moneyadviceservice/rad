module FcaTestHelpers
  class FakeContext < Hash
    attr_reader :data
    def write(d)
      @data ||= []
      @data << d
    end
  end

  def fixture(filename)
    File.open(File.join(Rails.root, 'spec/fixtures', filename))
  end
end
