RSpec.shared_context 'offices controller' do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:firm) do
    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names, fca_number: principal.fca_number)
    principal.firm.update_attributes(firm_attrs)
    principal.firm
  end
  let(:office) { FactoryGirl.create :office, firm: firm }
  let(:user)   { FactoryGirl.create :user, principal: principal }

  before do
    allow_any_instance_of(FcaApi::Request)
      .to receive(:get_firm)
      .and_return(instance_double(FcaApi::Response, ok?: true))
  end

  before { sign_in(user) }

  let(:address_line_one) { '120 Holborn' }
  let(:address_line_two) { 'Floor 5' }
  let(:postcode)         { 'EC1N 2TD' }

  let(:valid_attributes) do
    FactoryGirl.attributes_for(
      :office,
      address_line_one: address_line_one,
      address_line_two: address_line_two,
      address_postcode: postcode
    )
  end
end
