class Principal < ActiveRecord::Base
  before_create :generate_token

  validates :fca_number,
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

  def self.authenticate(token)
    principal = self.find_by(token: token)

    if principal
      principal.tap do |p|
        p.touch(:last_sign_in_at)
        yield(principal)
      end
    end
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
    self.token = SecureRandom.hex
  end
end
