RSpec.describe InactiveFirms::CreateUnapproved do
  let(:firm) { create(:firm, registered_name: 'Beasts', fca_number: 666666) }

  let(:last_inactive_firm) { InactiveFirm.last }

  def set_return(failure: false, valid: false, status: nil)
    mock = double('response', failure?: failure, valid?: valid, fca_status: status)

    allow(subject.send(:check_approved)).to receive(:call).and_return(mock)
  end

  context 'calling API via CheckApproved' do
    it 'returns false on failure' do
      set_return(failure: true)

      expect(subject.call(firm)).to eq false
    end

    it 'returns true if approved' do
      set_return(valid: true)

      expect(subject.call(firm)).to eq true
    end

    it 'returns truthy if unapproved' do
      set_return

      expect(subject.call(firm)).to be_truthy
    end

    it 'creates inactive_firm if not approved' do
      set_return

      expect { subject.call(firm) }.to change { InactiveFirm.count }.by 1
    end

    it 'values inactive_firm fields if not approved' do
      set_return(status: 'Dodgy')

      subject.call(firm)

      if last_inactive_firm
        expect(last_inactive_firm.firmable).to eq firm

        expect(last_inactive_firm.api_status).to eq 'Dodgy'
      end
    end
  end
end
