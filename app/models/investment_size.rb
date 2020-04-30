class InvestmentSize < ApplicationRecord
  include Translatable
  include FriendlyNamable

  # TODO: all the entities like this that are currently relating to firm need to be
  # migrated to relate to retirement firm in order to
  # make queries more efficient. This is a future refactor commit
  has_and_belongs_to_many :firms

  validates :name, presence: true

  default_scope { order(:order) }

  def self.lowest
    first
  end

  def lowest?
    self.class.lowest == self
  end
end
