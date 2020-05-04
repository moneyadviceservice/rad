class TravelInsuranceFirm < ApplicationRecord
  include FirmApproval
  # TODO: deprecate and remove the link to the principal, be sure to remove the columns. The firm handles this now
  belongs_to :principal, primary_key: :fca_number, foreign_key: :fca_number
  belongs_to :firm
end
