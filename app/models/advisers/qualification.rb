class Qualification < ApplicationRecord
  include FriendlyNamable

  validates :name, presence: true

  default_scope { order(:order) }

  def self.ransackable_attributes(*)
    %w[id name]
  end
end
