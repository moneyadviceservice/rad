class OpeningTime < ApplicationRecord
  attribute :open_saturday, :boolean
  attribute :open_sunday, :boolean

  belongs_to :office


  validates :weekday_opening_time, presence: true
  validates :weekday_closing_time, presence: true

  validates :saturday_opening_time, presence: true, if: :open_saturday
  validates :saturday_closing_time, presence: true, if: :open_saturday

  validates :sunday_opening_time, presence: true, if: :open_sunday
  validates :sunday_closing_time, presence: true, if: :open_sunday

  validate :weekday_opening_time_is_less_than_closing
  validate :saturday_opening_time_is_less_than_closing, if: :open_saturday
  validate :sunday_opening_time_is_less_than_closing, if: :open_sunday

  before_save :clear_opening_times

  def open_saturday?
    saturday_opening_time.present? || saturday_closing_time.present? || open_saturday
  end

  def open_sunday?
    sunday_opening_time.present? || sunday_closing_time.present? || open_sunday
  end

  private

  def clear_opening_times
    self.saturday_opening_time = self.saturday_closing_time = nil if open_saturday == false
    self.sunday_opening_time = self.sunday_closing_time = nil if open_sunday == false
  end

  def weekday_opening_time_is_less_than_closing
    return unless weekday_opening_time.present? && weekday_closing_time.present?
    return if weekday_opening_time < weekday_closing_time

    errors.add(:weekday_closing_time, 'cannot be before opening time')
  end

  def saturday_opening_time_is_less_than_closing
    return unless saturday_opening_time.present? && saturday_closing_time.present?
    return if saturday_opening_time < saturday_closing_time

    errors.add(:saturday_closing_time, 'cannot be before opening time')
  end

  def sunday_opening_time_is_less_than_closing
    return unless sunday_opening_time.present? && sunday_closing_time.present?
    return if sunday_opening_time < sunday_closing_time

    errors.add(:sunday_closing_time, 'cannot be before opening time')
  end
end
