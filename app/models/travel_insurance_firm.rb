class TravelInsuranceFirm < ApplicationRecord
  include FirmApproval
  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number
end
