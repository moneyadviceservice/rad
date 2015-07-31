RSpec.describe InvitationUptake do
  describe '#run' do
    describe 'result' do
      let(:data) { CSV.parse(subject.run) }
      let(:now)  { Time.zone.now }

      before :each do
        Timecop.freeze(now)
        @users = users
      end

      after :each do
        Timecop.return
      end

      context 'when the query does not return data' do
        let(:users) { [] }

        it 'generates a header row' do
          header_row = data[0]
          expect(header_row).to eq([
            'FCA Number',
            'Registered Name',
            'Invitation Sent',
            'Invitation Accepted',
            'Password Reset Sent'
          ])
        end

        it 'does not generate any other data' do
          expect(data.length).to eq(1)
        end
      end

      context 'when the query returns data' do
        let(:uninvited_user) do
          FactoryGirl.create(
            :user,
            invitation_sent_at: nil,
            invitation_accepted_at: nil,
            reset_password_sent_at: nil
          )
        end
        let(:invited_user) do
          FactoryGirl.create(
            :user,
            invitation_sent_at: 2.days.ago,
            invitation_accepted_at: nil,
            reset_password_sent_at: nil
          )
        end
        let(:accepted_user) do
          FactoryGirl.create(
            :user,
            invitation_sent_at: 2.days.ago,
            invitation_accepted_at: 1.day.ago,
            reset_password_sent_at: nil
          )
        end
        let(:reset_user) do
          FactoryGirl.create(
            :user,
            invitation_sent_at: 2.days.ago,
            invitation_accepted_at: 1.day.ago,
            reset_password_sent_at: 1.day.ago
          )
        end

        let(:users) { [uninvited_user, invited_user, accepted_user, reset_user] }

        it 'generates a header row' do
          header_row = data[0]
          expect(header_row).to eq([
            'FCA Number',
            'Registered Name',
            'Invitation Sent',
            'Invitation Accepted',
            'Password Reset Sent'
          ])
        end

        it 'generates a row of data per invited user and a header row' do
          expect(data.length).to eq(4)
        end

        it 'does not generate a row for the uninvited user' do
          expect(data).to_not include([
            uninvited_user.principal.fca_number.to_s,
            uninvited_user.principal.firm.registered_name,
            nil,
            nil,
            nil
          ])
        end

        it 'generates a row for the invited user' do
          expect(data).to include([
            invited_user.principal.fca_number.to_s,
            invited_user.principal.firm.registered_name,
            2.days.ago.strftime('%d-%b-%Y %H:%M'),
            nil,
            nil
          ])
        end

        it 'generates a row for the accepted user' do
          expect(data).to include([
            accepted_user.principal.fca_number.to_s,
            accepted_user.principal.firm.registered_name,
            2.days.ago.strftime('%d-%b-%Y %H:%M'),
            1.day.ago.strftime('%d-%b-%Y %H:%M'),
            nil
          ])
        end

        it 'generates a row for the reset user' do
          expect(data).to include([
            reset_user.principal.fca_number.to_s,
            reset_user.principal.firm.registered_name,
            2.days.ago.strftime('%d-%b-%Y %H:%M'),
            1.day.ago.strftime('%d-%b-%Y %H:%M'),
            1.day.ago.strftime('%d-%b-%Y %H:%M')
          ])
        end
      end
    end
  end
end
