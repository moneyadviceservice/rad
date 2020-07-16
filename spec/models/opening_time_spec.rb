RSpec.describe OpeningTime, type: :model do
  it { should belong_to(:office) }

  describe 'opening time validations' do
    context 'weekdays' do
      let(:opening_time) { build(:opening_time, weekday_opening_time: nil, weekday_closing_time: nil) }

      it 'validates weekday opening time is present' do
        opening_time.valid?

        expect(opening_time.errors[:weekday_opening_time]).to be_present
        expect(opening_time.errors[:weekday_closing_time]).to be_present
      end

      it 'validates opening time is less than closing time' do
        similar_time = 1.hour.ago
        opening_time = build(:opening_time, weekday_opening_time: similar_time, weekday_closing_time: similar_time)

        opening_time.valid?
        expect(opening_time.errors[:weekday_closing_time]).to be_present
      end

      it 'is valid when all times are correct' do
        opening_time = build(:opening_time, weekday_opening_time: '11:30', weekday_closing_time: '12:30')

        expect(opening_time).to be_valid
      end
    end

    context 'when office is open on saturday' do
      let(:opening_time) { build(:opening_time, open_saturday: true, saturday_opening_time: nil, saturday_closing_time: nil) }

      it 'validates saturday opening and closing times are present' do
        opening_time.valid?

        expect(opening_time.errors[:saturday_opening_time]).to be_present
        expect(opening_time.errors[:saturday_closing_time]).to be_present
      end

      it 'validates opening time is less than closing time' do
        similar_time = '12:30'
        opening_time = build(:opening_time, open_saturday: true, saturday_opening_time: similar_time, saturday_closing_time: similar_time)

        opening_time.valid?
        expect(opening_time.errors[:saturday_closing_time]).to be_present
      end

      it 'is valid when all times are correct' do
        opening_time = build(:opening_time, open_saturday: true, saturday_opening_time: '11:30', saturday_closing_time: '12:30')

        expect(opening_time).to be_valid
      end
    end

    context 'when office is open on sunday' do
      let(:opening_time) { build(:opening_time, open_sunday: true, sunday_opening_time: nil, sunday_closing_time: nil) }

      it 'validates sunday opening and closing times are present' do
        opening_time.valid?

        expect(opening_time.errors[:sunday_opening_time]).to be_present
        expect(opening_time.errors[:sunday_closing_time]).to be_present
      end

      it 'validates opening time is less than closing time' do
        similar_time = '12:30'
        opening_time = build(:opening_time, open_sunday: true, sunday_opening_time: similar_time, sunday_closing_time: similar_time)

        opening_time.valid?
        expect(opening_time.errors[:sunday_closing_time]).to be_present
      end

      it 'is valid when all times are correct' do
        opening_time = build(:opening_time, open_sunday: true, sunday_opening_time: '11:30', sunday_closing_time: '12:30')

        expect(opening_time).to be_valid
      end
    end
  end

  describe 'before_save' do
    let(:opening_time) { create(:opening_time, saturday_opening_time: 1.minute.ago, saturday_closing_time: 1.minute.from_now, sunday_opening_time: 1.minute.ago, sunday_closing_time: 1.minute.from_now) }

    it 'clears opening and closing time for saturday if set to nil' do
      opening_time.open_saturday = false
      opening_time.save
      expect(opening_time.saturday_opening_time).to be_nil
      expect(opening_time.saturday_closing_time).to be_nil
    end

    it 'clears opening and closing time for sunday if set to nil' do
      opening_time.open_sunday = false
      opening_time.save
      expect(opening_time.sunday_opening_time).to be_nil
      expect(opening_time.sunday_closing_time).to be_nil
    end

    it 'opening times are no cleared if not set to false' do
      opening_time.save
      expect(opening_time.sunday_opening_time).not_to be_nil
      expect(opening_time.sunday_closing_time).not_to be_nil
    end
  end
end
