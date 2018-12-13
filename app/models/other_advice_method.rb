class OtherAdviceMethod < ActiveRecord::Base
  include Translatable
  include FriendlyNamable
  include SystemNameable

  SYSTEM_NAMES = {
    1 => :phone,
    2 => :online
  }.freeze

  has_and_belongs_to_many :firms

  validates :name, presence: true

  default_scope { order(:order) }
end
