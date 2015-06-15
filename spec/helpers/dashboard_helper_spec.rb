RSpec.describe Dashboard::DashboardHelper, type: :helper do
  describe '#number_of_advisers' do
    it 'counts both parent and trading name advisers' do
      firm = FactoryGirl.create(:firm_with_advisers, advisers_count: 1)
      FactoryGirl.create(:firm_with_advisers, fca_number: firm.fca_number, advisers_count: 1)
      FactoryGirl.create(:firm_with_advisers, fca_number: firm.fca_number, advisers_count: 2)

      expect(helper.number_of_advisers(firm)).to eq(4)
    end
  end

  describe '#most_recently_edited_advisers' do
    it 'returns an empty list when there are no advisers' do
      firm = FactoryGirl.create(:firm)
      expect(helper.most_recently_edited_advisers(firm)).to eq([])
    end

    it 'returns one adviser when there is one adviser' do
      firm = FactoryGirl.create(:firm_with_advisers, advisers_count: 1)
      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent.length).to eq(1)
      expect(most_recent[0]).to eq(firm.advisers.first)
    end

    it 'provides three advisers when there are four advisers' do
      firm = FactoryGirl.create(:firm)
      FactoryGirl.create_list(:adviser, 4, firm_id: firm.id)

      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent.length).to eq(3)
    end

    it 'provides the three most recently edited advisers when there are four advisers' do
      firm = FactoryGirl.create(:firm)
      first_adviser = FactoryGirl.create(:adviser, firm_id: firm.id, updated_at: 2.weeks.ago)
      second_adviser = FactoryGirl.create(:adviser, firm_id: firm.id, updated_at: 1.weeks.ago)
      fourth_adviser = FactoryGirl.create(:adviser, firm_id: firm.id, updated_at: 3.weeks.ago)
      FactoryGirl.create(:adviser, firm_id: firm.id, updated_at: 4.weeks.ago)

      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent[0]).to eq(second_adviser)
      expect(most_recent[1]).to eq(first_adviser)
      expect(most_recent[2]).to eq(fourth_adviser)
    end

    it 'accounts for advisers on trading names of the firm' do
      firm = FactoryGirl.create(:firm)
      trading_name = FactoryGirl.create(:trading_name, fca_number: firm.fca_number)
      FactoryGirl.create(:adviser, firm_id: firm.id)
      FactoryGirl.create(:adviser, firm_id: trading_name.id)

      most_recent = helper.most_recently_edited_advisers(firm)
      expect(most_recent.length).to eq(2)
    end
  end
end
