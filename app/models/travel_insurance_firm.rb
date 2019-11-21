class TravelInsuranceFirm < ApplicationRecord
  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number
end
