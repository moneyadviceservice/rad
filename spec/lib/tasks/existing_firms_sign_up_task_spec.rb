module Tasks
  RSpec.describe ExistingFirmsSignUpTask do
    describe '#notify' do
      let!(:bills_firm) { create :firm }
      let!(:bill) { create :principal, email_address: 'bill@example.com', firm: bills_firm }

      before do
        ActionMailer::Base.deliveries = []
      end

      it 'mails principals that have no account' do
        create :principal, email_address: 'ben@example.com', firm: create(:firm)

        described_class.notify

        expect(emails_sent.size).to eq(2)
        expect(emails_sent).to all(have_attributes(subject: 'Invitation instructions'))

        emails_sent.sort_by(&:to).tap do |sorted_emails_sent|
          expect(sorted_emails_sent.first.to).to include('ben@example.com')
          expect(sorted_emails_sent.last.to).to include(bill.email_address)
        end
      end

      it 'mails only principals for firms with no parent' do
        subsidiary = create(:firm, parent: bills_firm)
        create :principal, email_address: 'firm@example.com', firm: bills_firm
        create :principal, email_address: 'subsidiary@example.com', firm: subsidiary

        described_class.notify

        expect(emails_sent.first.to).to include('firm@example.com')
      end

      it 'does not mail principals thats firm is not registered' do
        bill.firm.update_attribute(:email_address, nil)

        described_class.notify

        expect(emails_sent).to be_empty
      end

      it 'does not mail principals thats firm are invalid' do
        bill.firm.update_attribute(:telephone_number, nil)

        described_class.notify

        expect(emails_sent).to be_empty
      end

      it 'does not mail principals that have an already have an account' do
        create :user, principal: bill
        allow_any_instance_of(User).to receive(:invited_to_sign_up?).and_return(false)

        described_class.notify

        expect(emails_sent).to be_empty
      end

      it 'does not mail principals that have an account' do
        create :user, principal: bill
        allow_any_instance_of(User).to receive(:invited_to_sign_up?).and_return(false)

        described_class.notify

        expect(emails_sent).to be_empty
      end

      context 'rerunning task' do
        it 'mails principals that have an account that have not accepted an invitation' do
          create :user, principal: bill
          allow_any_instance_of(User).to receive(:invited_to_sign_up?).and_return(true)
          allow_any_instance_of(User).to receive(:invitation_accepted?).and_return(false)

          described_class.notify

          expect(emails_sent.size).to eq(1)
          expect(emails_sent.first.subject).to eq('Invitation instructions')
        end

        it 'does not mail principals that have not been previously invited' do
          create :user, principal: bill
          allow_any_instance_of(User).to receive(:invited_to_sign_up?).and_return(false)

          described_class.notify

          expect(emails_sent.size).to eq(0)
        end

        it 'does not mail principals that have been invited and accepted the invitation' do
          create :user, principal: bill
          allow_any_instance_of(User).to receive(:invited_to_sign_up?).and_return(true)
          allow_any_instance_of(User).to receive(:invitation_accepted?).and_return(true)

          described_class.notify

          expect(emails_sent.size).to eq(0)
        end
      end

      private

      def emails_sent
        ActionMailer::Base.deliveries
      end
    end
  end
end
