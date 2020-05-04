class InactiveFirm < ApplicationRecord
  belongs_to :retirement_firm

  delegate :fca_number, :registered_name, :publishable?, to: :firm
end
