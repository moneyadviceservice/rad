RSpec.describe Dashboard::DashboardHelper, type: :helper do
  describe '#number_of_advisers' do
    it 'counts both parent and trading name advisers' do
      first_trading_name = Firm.new advisers: [Adviser.new]
      second_trading_name = Firm.new advisers: [Adviser.new, Adviser.new]

      trading_names = [first_trading_name, second_trading_name]
      firm = Firm.new(trading_names: trading_names, advisers: [Adviser.new])

      expect(helper.number_of_advisers(firm)).to eq(4)
    end
  end

  describe '#most_recently_edited_advisers' do
    it 'returns and empty list when there are no advisers' do
      firm = Firm.new(advisers: [])
      expect(helper.most_recently_edited_advisers(firm)).to eq([])
    end

    it 'returns three advisers when there is one adviser' do
      adviser = Adviser.new(reference_number: 'ABC12345')
      firm = Firm.new(advisers: [adviser])

      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent.length).to eq(3)
      expect(most_recent[0]).to eq(adviser)
      expect(most_recent[1]).to be_nil
      expect(most_recent[2]).to be_nil
    end

    it 'returns three advisers when there is two advisers' do
      first_adviser = Adviser.new(reference_number: 'ABC12345', updated_at: 1.week.ago)
      second_adviser = Adviser.new(reference_number: 'XYZ12345', updated_at: 2.weeks.ago)
      advisers = [first_adviser, second_adviser]
      firm = Firm.new(advisers: advisers)

      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent.length).to eq(3)
      expect(most_recent[0]).to eq(first_adviser)
      expect(most_recent[1]).to eq(second_adviser)
      expect(most_recent[2]).to be_nil
    end

    it 'returns three advisers when there is three advisers' do
      first_adviser = Adviser.new(reference_number: 'ABC12345', updated_at: 1.week.ago)
      second_adviser = Adviser.new(reference_number: 'XYZ12345', updated_at: 2.weeks.ago)
      third_adviser = Adviser.new(reference_number: 'QWE12345', updated_at: 3.weeks.ago)
      advisers = [first_adviser, second_adviser, third_adviser]
      firm = Firm.new(advisers: advisers)

      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent.length).to eq(3)
      expect(most_recent[0]).to eq(first_adviser)
      expect(most_recent[1]).to eq(second_adviser)
      expect(most_recent[2]).to eq(third_adviser)
    end

    it 'provides the three most recently edited advisers when there are many advisers' do
      first_adviser = Adviser.new(reference_number: 'AAA12345', updated_at: 1.week.ago)
      second_adviser = Adviser.new(reference_number: 'BBB12345', updated_at: 2.weeks.ago)
      third_adviser = Adviser.new(reference_number: 'CCC12345', updated_at: 3.weeks.ago)
      fourth_adviser = Adviser.new(reference_number: 'DDD12345', updated_at: 4.weeks.ago)

      first_trading_name = Firm.new advisers: [third_adviser]
      second_trading_name = Firm.new advisers: [first_adviser]

      trading_names = [first_trading_name, second_trading_name]
      firm = Firm.new(trading_names: trading_names, advisers: [fourth_adviser, second_adviser])

      most_recent = helper.most_recently_edited_advisers(firm)

      expect(most_recent.length).to eq(3)
      expect(most_recent[0]).to eq(first_adviser)
      expect(most_recent[1]).to eq(second_adviser)
      expect(most_recent[2]).to eq(third_adviser)
    end
  end
end
