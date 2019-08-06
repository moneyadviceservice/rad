RSpec.shared_context 'advisers controller' do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:adviser) { FactoryGirl.create(:adviser) }
  let(:firm) do FactoryGirl.build(
    :firm_with_trading_names,
    fca_number: principal.fca_number,
    advisers: [adviser])
  end
  let(:user) { FactoryGirl.create :user, principal: firm.principal }
  
  before do
    principal.firm = firm
    sign_in(user)
  end
end
