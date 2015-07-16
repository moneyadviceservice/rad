class StubInvitationHelper
  def invitation_url(user)
    "invitation for user #{user.id}"
  end
end

module Tasks
  RSpec.describe ExistingFirmsSignUpTask do
    describe '#notify' do
      let!(:firm) { create :firm, registered_name: 'Wright, Johnston & MacKenzie LLP' }
      let!(:principal) { create :principal, firm: firm, first_name: 'Bill', last_name: 'Junior, the third' }
      let(:stub_inviter) { StubInvitationHelper.new }
      let(:output) { [] }

      it 'invites principals that have no account' do
        expect(User.count).to eq(0)
        described_class.notify(stub_inviter, output)
        expect(User.first).to be_invited_to_sign_up
      end

      it 'sets user.invitation_sent_at' do
        expected_invitation_sent_at = DateTime.current
        allow(DateTime).to receive(:current).and_return(expected_invitation_sent_at)

        described_class.notify(stub_inviter, output)
        expect(User.first.invitation_sent_at.to_datetime).to be_within(1.second).of(expected_invitation_sent_at)
      end

      it 'invites but does not send email' do
        ActionMailer::Base.deliveries = []
        described_class.notify(stub_inviter, output)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      describe 'when creating a csv entry for a principal' do
        before do
          described_class.notify(stub_inviter, output)
        end

        it 'contains the frn' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[0].to_i).to eq(principal.firm.fca_number)
          end
        end

        it 'contains the firm name' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[1]).to eq(principal.firm.registered_name)
          end
        end

        it 'contains the principal name' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[2]).to eq(principal.full_name)
          end
        end

        it 'contains the email' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[3]).to eq(principal.email_address)
          end
        end

        it 'contains the invitation url' do
          CSV.parse(output.first) do |line_data|
            expected_output = stub_inviter.invitation_url(User.first)
            expect(line_data[4]).to eq(expected_output)
          end
        end
      end

      it 'does not create output for trading names' do
        subsidiary = create(:firm, parent: firm)
        create :principal, email_address: 'firm@example.com', firm: firm
        create :principal, email_address: 'tradingname@example.com', firm: subsidiary

        described_class.notify(stub_inviter, output)

        expect(output.length).to eq(1)
        CSV.parse(output.first) do |line_data|
          expect(line_data[3]).to eq('firm@example.com')
        end
      end

      it 'does not output including details where the firm is not registered' do
        principal.firm.update_attribute(:email_address, nil)

        described_class.notify(stub_inviter, output)

        expect(output).to be_empty
      end

      it 'does not create output including details where the firm is not registered' do
        principal.firm.update_attribute(:telephone_number, nil)

        described_class.notify(stub_inviter, output)

        expect(output).to be_empty
      end

      it 'does not create output including details where the firm already has an account' do
        create :user, principal: principal

        described_class.notify(stub_inviter, output)

        expect(output).to be_empty
      end
    end
  end
end
