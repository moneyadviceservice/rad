module Tasks
  RSpec.describe UserInvitationHelper do
    describe '#invitation_url' do
      it 'generates the invitation_url' do
        user = User.new

        Rails.application.config.action_mailer.default_url_options[:host] = 'example.com'
        allow(user).to receive(:raw_invitation_token).and_return('my_raw_invite_token')

        expected_url = 'http://example.com/users/invitation/accept?invitation_token=my_raw_invite_token'
        expect(subject.invitation_url(user)).to eq(expected_url)
      end
    end
  end
end
