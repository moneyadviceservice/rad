class InactiveFirm < ApplicationRecord
  belongs_to :firm

  delegate :fca_number, :registered_name, :publishable?, to: :firm
end
