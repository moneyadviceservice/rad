class InvestmentSize < ActiveRecord::Base
  has_many :firms

  validates :name, presence: true
end
