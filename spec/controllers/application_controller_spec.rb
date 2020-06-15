require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  describe ':Admin email' do
    it 'should be the default Emailer :from' do
      expect(subject.admin_email_address).to eq(ENV['RAD_ADMIN_EMAIL'])
    end
  end
end
