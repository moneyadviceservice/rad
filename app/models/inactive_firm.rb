class InactiveFirm < ActiveRecord::Base
  belongs_to :firm

  delegate :fca_number, :registered_name, :publishable?, to: :firm
end
