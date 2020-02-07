require 'spec_helper'

RSpec.describe TravelInsuranceRegistrationsController, type: :controller do
  it 'should have overriden admin email address' do
    expect(subject.admin_email_address).to eq('traveldirectory@maps.org.uk')
  end
end
