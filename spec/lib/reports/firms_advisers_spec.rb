RSpec.describe Reports::FirmsAdvisers do
  describe '#data' do
    subject(:data_with_header) { CSV.parse(Reports::FirmsAdvisers.data) }
    subject(:data_without_header) do
      data = data_with_header
      data.shift
      data
    end

    before :each do
      @firm_count = 3

      @firms = FactoryGirl.create_list(:principal, @firm_count).map(&:firm)
    end

    it 'has a header row' do
      expect(data_with_header.first).to eq(Reports::FirmsAdvisers::HEADER_ROW)
    end

    it 'has a row for each firm' do
      expect(data_without_header.size).to eq(@firm_count)
    end

    describe 'each firm row' do
      COL_FCA_NUMBER    = 0
      COL_NAME          = 1
      COL_PRINCIPAL     = 2
      COL_EMAIL         = 3
      COL_ADVICE_METHOD = 4
      COL_ADVISER_COUNT = 5

      it 'has an FCA Number' do
        @firms.each_with_index do |firm, i|
          expect(firm.fca_number).not_to be_nil
          expect(data_without_header[i][COL_FCA_NUMBER]).to eq(firm.fca_number.to_s)
        end
      end

      it 'has a Name' do
        @firms.each_with_index do |firm, i|
          expect(firm.registered_name).not_to be_nil
          expect(data_without_header[i][COL_NAME]).to eq(firm.registered_name)
        end
      end

      it 'has a Principal' do
        @firms.each_with_index do |firm, i|
          expect(firm.principal.full_name).not_to be_nil
          expect(data_without_header[i][COL_PRINCIPAL]).to eq(firm.principal.full_name)
        end
      end

      it 'has an Email Address' do
        @firms.each_with_index do |firm, i|
          expect(firm.principal.email_address).not_to be_nil
          expect(data_without_header[i][COL_EMAIL]).to eq(firm.principal.email_address)
        end
      end
    end

    describe 'advice method' do
      before :each do
        @firms[0].in_person_advice_methods.create(FactoryGirl.attributes_for(:in_person_advice_method))
        @firms[1].in_person_advice_methods.create(FactoryGirl.attributes_for(:in_person_advice_method))
        @firms[2].other_advice_methods.create(FactoryGirl.attributes_for(:other_advice_method))
      end

      it 'shows local if the firm is local' do
        expect(data_without_header[0][COL_ADVICE_METHOD]).to eq('local')
        expect(data_without_header[1][COL_ADVICE_METHOD]).to eq('local')
      end

      it 'shows remote if the firm is remote' do
        expect(data_without_header[2][COL_ADVICE_METHOD]).to eq('remote')
      end
    end

    describe 'adviser count' do
      before :each do
        FactoryGirl.create(:adviser, firm: @firms[1])
        FactoryGirl.create(:adviser, firm: @firms[1])
        FactoryGirl.create(:adviser, firm: @firms[2])
      end

      it 'shows 0 if a firm has no advisers' do
        expect(data_without_header[0][COL_ADVISER_COUNT]).to eq('0')
      end

      it 'shows the number of advisers if a firm has advisers' do
        expect(data_without_header[1][COL_ADVISER_COUNT]).to eq('2')
        expect(data_without_header[2][COL_ADVISER_COUNT]).to eq('1')
      end
    end
  end
end
