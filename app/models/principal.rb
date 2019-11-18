class Principal < ApplicationRecord
  self.primary_key = 'token'

  before_create :generate_token

  has_one :user, foreign_key: :principal_token
  has_one :firm,
          -> { where(parent_id: nil) },
          primary_key: :fca_number,
          foreign_key: :fca_number,
          dependent: :destroy

  has_one :travel_insurance_firm,
    primary_key: :fca_number,
    foreign_key: :fca_number,
    dependent: :destroy

  validates :fca_number,
            presence: true,
            uniqueness: true,
            length: { is: 6 },
            numericality: { only_integer: true }

  validates :email_address,
            presence: true,
            uniqueness: true,
            length: { maximum: 50 },
            format: { with: /.+@.+\..+/ }

  validates :first_name, :last_name, :job_title, presence: true, length: 2..80

  validates :telephone_number,
            presence: true,
            length: { maximum: 50 },
            format: { with: /\A[0-9 ]+\z/ }

  validates :confirmed_disclaimer, acceptance: { accept: true }

  def main_firm_with_trading_names
    Firm.where(fca_number: fca_number)
  end

  def to_param
    token.parameterize
  end

  def lookup_firm
    @lookup_firm ||= Lookup::Firm.find_by(fca_number: fca_number)
  end

  def field_order
    %i[
      fca_number
      first_name
      last_name
      job_title
      email_address
      telephone_number
      confirmed_disclaimer
    ]
  end

  def find_or_create_subsidiary(id)
    subsidiary = lookup_firm.subsidiaries.find(id)

    find_subsidiary(subsidiary).tap do |firm|
      firm.save(validate: false) unless firm.persisted?
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def onboarded?
    main_firm_with_trading_names.any?(&:publishable?)
  end

  private

  def find_subsidiary(subsidiary)
    firm.subsidiaries.find_or_initialize_by(
      registered_name: subsidiary.name,
      fca_number: subsidiary.fca_number
    )
  end

  def generate_token
    self.token = SecureRandom.hex(4)
  end
end
