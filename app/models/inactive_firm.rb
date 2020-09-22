class InactiveFirm < ApplicationRecord
  belongs_to :firmable, polymorphic: true

  delegate :fca_number, :registered_name, :publishable?, to: :firmable

  scope :retirement, -> { where(firmable_type: 'Firm') }
  scope :travel, -> { where(firmable_type: 'TravelInsuranceFirm') }
end
