RSpec.describe Admin::Reports::RegisteredAdviserController, type: :controller do
  describe '#filename' do
    context 'timestamp' do
      let(:date) { Date.new(2017, 5, 29) }

      it 'returns filename with timestamp included' do
        Timecop.freeze(date)
        expect(controller.send(:filename)).to eq('registered_advisers_2017-05-29')
        Timecop.return
      end
    end
  end
end
