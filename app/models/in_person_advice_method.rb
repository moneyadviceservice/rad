class InPersonAdviceMethod < ApplicationRecord
  include FriendlyNamable

  has_and_belongs_to_many :retirement_firms, through: :retirement_firms_in_person_advice_methods

  validates :name, presence: true

  default_scope { order(:order) }
end
