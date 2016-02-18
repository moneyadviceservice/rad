RSpec.describe Admin::FirmsController, type: :controller do
  def create_user_with_firm(user_attrs, firm_attrs = {})
    principal = FactoryGirl.create(:principal)

    firm_attrs = FactoryGirl.attributes_for(:firm_with_trading_names,
                                            fca_number: principal.fca_number).merge(firm_attrs)
    principal.firm.update_attributes!(firm_attrs)

    FactoryGirl.create :user, { principal: principal }.merge(user_attrs)
  end

  describe '#login_report' do
    let!(:first_user)  { create_user_with_firm({ invitation_accepted_at: Time.zone.today }, registered_name: 'Delta') }
    let!(:second_user) { create_user_with_firm({ invitation_accepted_at: Time.zone.today }, registered_name: 'Alpha') }
    let!(:third_user)  { create_user_with_firm({ invitation_accepted_at: nil }, registered_name: 'Gamma') }
    let!(:fourth_user)  { create_user_with_firm({ invitation_accepted_at: nil }, registered_name: 'Charlie') }

    before :each do
      get :login_report
    end

    describe 'accepted_firms assignment' do
      it 'assigns records that have accepted an invitation' do
        expect(assigns(:accepted_firms)).to include(first_user, second_user)
        expect(assigns(:accepted_firms)).to_not include(third_user, fourth_user)
      end

      it 'orders the firms by registered name' do
        expect(assigns(:accepted_firms).pluck(:registered_name)).to eq(%w(Alpha Delta))
      end
    end

    describe 'not_accepted_firms assignment' do
      it 'assigns records that have not accepted their invitation' do
        expect(assigns(:not_accepted_firms)).to include(third_user, fourth_user)
        expect(assigns(:not_accepted_firms)).to_not include(first_user, second_user)
      end

      it 'orders the firms by registered name' do
        expect(assigns(:not_accepted_firms).pluck(:registered_name)).to eq(%w(Charlie Gamma))
      end
    end
  end

  describe 'GET adviser_report' do
    before :each do
      allow(Reports::FirmsAdvisers).to receive(:data)

      Timecop.freeze(Time.zone.parse('2016-05-04 00:00:00'))

      get :adviser_report, format: :csv
    end

    after :each do
      Timecop.return
    end

    it 'gets data from the Firms report' do
      expect(Reports::FirmsAdvisers).to have_received(:data)
    end

    it 'provides it as a CSV' do
      expect(response.header['Content-Type']).to eq('text/csv')
    end

    it 'has a timestamped filename' do
      expect(response.header['Content-Disposition']).to eq('attachment; filename="firms-advisers-20160504000000.csv"')
    end
  end
end
