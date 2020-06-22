class OpeningTime < ApplicationRecord
  attribute :open_saturday, :boolean
  attribute :open_sunday, :boolean

  belongs_to :office

  validates_presence_of :weekday_opening_time, :weekday_closing_time
  validates_presence_of :saturday_opening_time, :saturday_closing_time, if: :open_saturday
  validates_presence_of :sunday_opening_time, :sunday_closing_time, if: :open_sunday

  before_save :clear_opening_times

  def open_saturday?
    saturday_opening_time.present? || saturday_closing_time.present? || open_saturday
  end

  def open_sunday?
    sunday_opening_time.present? || sunday_closing_time.present? || open_sunday
  end

  private

  def clear_opening_times
    if open_saturday == false
      self.saturday_opening_time = self.saturday_closing_time = nil
    end
    
    if open_sunday == false
      self.sunday_opening_time = self.sunday_closing_time = nil
    end    
  end
end
