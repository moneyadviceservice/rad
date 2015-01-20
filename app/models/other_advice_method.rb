class OtherAdviceMethod < ActiveRecord::Base
  has_and_belongs_to_many :firms

  validates :name, presence: true
end
