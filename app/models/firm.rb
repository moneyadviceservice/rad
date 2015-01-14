class Firm < ActiveRecord::Base
  has_many :advisers

  validates :email_address,
            presence: true,
            length: { maximum: 50 },
            format: { with: /.+@.+\..+/ }

  validates :telephone_number,
            presence: true,
            length: { maximum: 30 },
            format: { with: /\A[0-9 ]+\z/ }
end
