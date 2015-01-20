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

  validates :address_line_1,
            presence: true,
            length: { maximum: 100 }

  validates :address_line_2,
            presence: true,
            length: { maximum: 100 }

  validates :address_postcode,
            presence: true,
            format: { with: /\A[a-zA-Z\d]{1,4} [a-zA-Z\d]{1,3}\z/ }

  validates :address_town,
            :address_county,
            presence: true
end
