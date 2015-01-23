class AllowedPaymentMethod < ActiveRecord::Base
  has_and_belongs_to_many :firms

  validates_presence_of :name
end
