class Firm < ActiveRecord::Base
  has_and_belongs_to_many :service_regions
  has_and_belongs_to_many :in_person_advice_methods
  has_and_belongs_to_many :other_advice_methods

  belongs_to :initial_meeting_duration

  has_and_belongs_to_many :initial_advice_fee_structures
  has_and_belongs_to_many :ongoing_advice_fee_structures
  has_and_belongs_to_many :allowed_payment_methods
  has_and_belongs_to_many :investment_sizes

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
            length: { maximum: 100 }

  validates :address_postcode,
            presence: true,
            format: { with: /\A[a-zA-Z\d]{1,4} [a-zA-Z\d]{1,3}\z/ }

  validates :address_town,
            :address_county,
            presence: true

  validates :service_regions,
            length: { minimum: 1 }

  validates :in_person_advice_methods,
            length: { minimum: 1 }

  validates :other_advice_methods,
            length: { minimum: 1 }

  validates :free_initial_meeting,
            inclusion: { in: [true, false] }

  validates :initial_meeting_duration,
            presence: true,
            if: ->{ free_initial_meeting }

  validates :initial_advice_fee_structures,
            length: { minimum: 1 }

  validates :ongoing_advice_fee_structures,
            length: { minimum: 1 }

  validates :allowed_payment_methods,
            length: { minimum: 1 }

  validates :minimum_fixed_fee,
            allow_blank: true,
            numericality: { only_integer: true }

  validates :investment_sizes,
            length: { minimum: 1 }
end
