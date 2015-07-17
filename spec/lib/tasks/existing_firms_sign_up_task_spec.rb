class StubInvitationHelper
  def invitation_url(user)
    "invitation for user #{user.id}"
  end
end

module Tasks
  RSpec.describe ExistingFirmsSignUpTask do
    describe '#notify' do
      let(:stub_inviter) { StubInvitationHelper.new }
      let(:output) { [] }

      before do
        @principal = FactoryGirl.create(:principal)

        firm_attrs = FactoryGirl.attributes_for(:firm,
                                                fca_number: @principal.fca_number,
                                                registered_name: @principal.lookup_firm.registered_name)
        @principal.firm.update_attributes(firm_attrs)
        @firm = @principal.firm
      end

      it 'invites principals that have no account' do
        described_class.notify(stub_inviter, output)
        expect(User.count).to eq(1)
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
            expect(line_data[0].to_i).to eq(@principal.firm.fca_number)
          end
        end

        it 'contains the firm name' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[1]).to eq(@principal.firm.registered_name)
          end
        end

        it 'contains the principal name' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[2]).to eq(@principal.full_name)
          end
        end

        it 'contains the email' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[3]).to eq(@principal.email_address)
          end
        end

        it 'contains the invitation url' do
          CSV.parse(output.first) do |line_data|
            expected_output = stub_inviter.invitation_url(User.first)
            expect(line_data[4]).to eq(expected_output)
          end
        end

        it 'contains the registered flag' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[5]).to eq('registered')
          end
        end
      end

      context 'when principal has not verified account via email link' do
        before do
          @firm.update_attribute :email_address, nil
          described_class.notify(stub_inviter, output)
        end

        it 'contains the registered flag' do
          CSV.parse(output.first) do |line_data|
            expect(line_data[5]).to eq('not registered')
          end
        end
      end

      context 'when firm has trading names' do
        it 'does not create output for trading names' do
          @firm.subsidiaries = create_list(:trading_name, 3, fca_number: @firm.fca_number)
          @firm.save!
          described_class.notify(stub_inviter, output)

          expect(output.length).to eq(1)
          CSV.parse(output.first) do |line_data|
            expect(line_data[1]).to eq(@principal.firm.registered_name)
          end
        end
      end

      it 'does not create output including details where the firm already has an account' do
        create :user, principal: @principal

        described_class.notify(stub_inviter, output)

        expect(output).to be_empty
      end
    end
  end
end
