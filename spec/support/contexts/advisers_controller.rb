RSpec.shared_context 'advisers controller' do
  let(:principal) { FactoryBot.create(:principal) }
  let(:adviser) { FactoryBot.create(:adviser) }
  let(:firm) do
    firm_attrs = FactoryBot.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
    firm_attrs[:advisers] = [adviser]
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:user) { FactoryBot.create :user, principal: firm.principal }
  before { sign_in(user) }
end
