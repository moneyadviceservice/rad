class InitialAdviceFeeStructure < ApplicationRecord
  has_and_belongs_to_many :retirement_firms

  validates :name, presence: true

  default_scope { order(:order) }
end
