class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :recoverable, :rememberable, :trackable, :registerable,
         :secure_validatable, :password_archivable, :password_expirable,
         authentication_keys: [:login]

  validates :email, email: { validate_mx: false, allow_idn: false }

  belongs_to :principal, inverse_of: :user, foreign_key: :principal_token

  accepts_nested_attributes_for :principal

  attr_accessor :login

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    fca_number = conditions.delete(:login)
    return nil if fca_number.blank?

    find_user_by_fca_number(conditions, fca_number: fca_number)
  end

  def self.find_user_by_fca_number(conditions, fca_number:)
    where(conditions.to_hash)
      .joins(:principal)
      .find_by(
        ['principals.fca_number = :fca_number', { fca_number: fca_number.to_i }]
      )
  end
end
