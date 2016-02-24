RSpec.shared_context 'offices controller' do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:firm) do
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:office) { firm.offices.first }
  let(:user)   { FactoryGirl.create :user, principal: principal }

  before { sign_in(user) }
end
