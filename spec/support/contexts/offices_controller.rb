RSpec.shared_context 'offices controller' do
  let(:principal) { FactoryGirl.create(:principal) }
  let(:firm) do
    FactoryGirl.build(
      :firm_with_trading_names,
      fca_number: principal.fca_number
    )
  end

  let(:office) { FactoryGirl.create :office, firm: firm }
  let(:user)   { FactoryGirl.create :user, principal: principal }

  before do
    principal.firm = firm
    sign_in(user)
  end

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
