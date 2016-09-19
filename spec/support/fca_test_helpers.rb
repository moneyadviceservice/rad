module FcaTestHelpers
  def fixture(filename)
    File.open(Rails.root.join('spec/fixtures', filename), 'r')
  end
end
