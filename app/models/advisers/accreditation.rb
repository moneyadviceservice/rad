class Accreditation < ApplicationRecord
  include FriendlyNamable

  validates :name, presence: true

  default_scope { order(:order) }
end
