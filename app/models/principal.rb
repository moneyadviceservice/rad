class Principal < ActiveRecord::Base
  self.primary_key = 'token'

  before_create :generate_token

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

  validates :website_address,
    allow_blank: true,
    length: { maximum: 100 }

  validates_acceptance_of :confirmed_disclaimer, accept: true

  validate :match_fca_number

  def to_param
    token.parameterize
  end

  def firm
    Lookup::Firm.find_by(fca_number: fca_number)
  end

  delegate :subsidiaries?, to: :firm

  def field_order
    [
      :fca_number,
      :website_address,
      :first_name,
      :last_name,
      :job_title,
      :email_address,
      :telephone_number,
      :confirmed_disclaimer
    ]
  end

  private

  def match_fca_number
    unless Lookup::Firm.exists?(fca_number: self.fca_number)
      errors.add(
        :fca_number,
        I18n.t('registration.principal.fca_number_un_matched')
      )
    end
  end

  def generate_token
    self.token = SecureRandom.hex(4)
  end
end
