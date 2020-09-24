RSpec.describe InactiveFirm, type: :model do
  it { should belong_to :firmable }

  it { should delegate_method(:fca_number).to(:firmable) }
  it { should delegate_method(:registered_name).to(:firmable) }
  it { should delegate_method(:publishable?).to(:firmable) }
end
