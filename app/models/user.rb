class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable,
         :recoverable, :rememberable, :trackable, :registerable,
         :secure_validatable, :password_archivable, :password_expirable,
         authentication_keys: [:login]

  validates :email, email: { validate_mx: false, allow_idn: false }

  belongs_to :principal, foreign_key: :principal_token

  accepts_nested_attributes_for :principal

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    email_or_frn = conditions.delete(:login)
    return nil unless email_or_frn.present?

    find_user_by_email_or_frn(conditions, email_or_frn: email_or_frn)
  end

  def self.find_user_by_email_or_frn(conditions, email_or_frn:)
    where(conditions.to_hash)
      .joins(:principal)
      .find_by(
        [
          '(lower(users.email) = :email OR principals.fca_number = :fca_number)',
          { email: email_or_frn.downcase, fca_number: email_or_frn.to_i }
        ]
      )
  end
end
