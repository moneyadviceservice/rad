RSpec.shared_context 'advisers controller' do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:adviser) { FactoryGirl.create(:adviser) }
  let(:firm) do
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
    firm_attrs[:advisers] = [adviser]
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:user) { FactoryGirl.create :user, principal: firm.principal }

  before do
    allow_any_instance_of(FcaApi::Request)
      .to receive(:get_firm)
      .and_return(instance_double(FcaApi::Response, ok?: true))
  end

  before { sign_in(user) }
end
