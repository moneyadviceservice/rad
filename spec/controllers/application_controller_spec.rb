require 'spec_helper'

RSpec.describe ApplicationController, type: :controller do
  describe ':A:Adefault from email' do
    controller(ApplicationController) do
    end

    it 'should be the default Emailer :from' do
      expect(subject.admin_email_address).to eq(ActionMailer::Base.default[:from])
    end
  end
end
