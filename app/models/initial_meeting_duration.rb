class InitialMeetingDuration < ActiveRecord::Base
  has_many :firms

  validates :duration, presence: true
end
