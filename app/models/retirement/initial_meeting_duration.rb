class InitialMeetingDuration < ApplicationRecord
  has_many :firms

  validates :name, presence: true

  default_scope { order(:order) }
end
