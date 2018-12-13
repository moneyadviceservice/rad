class Qualification < ActiveRecord::Base
  include FriendlyNamable

  validates :name, presence: true

  default_scope { order(:order) }
end
