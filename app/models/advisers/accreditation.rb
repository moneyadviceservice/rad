class Accreditation < ApplicationRecord
  include FriendlyNamable

  validates :name, presence: true

  default_scope { order(:order) }

  def self.ransackable_attributes(*)
    %w[name id]
  end

  def self.ransackable_associations(*)
    []
  end
end
