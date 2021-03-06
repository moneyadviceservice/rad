class OngoingAdviceFeeStructure < ApplicationRecord
  has_and_belongs_to_many :firms

  validates :name, presence: true

  default_scope { order(:order) }
end
