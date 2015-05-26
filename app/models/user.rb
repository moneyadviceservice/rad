class User < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :recoverable,
         :recoverable, :rememberable, :trackable, :registerable,
         :secure_validatable, :password_archivable, :password_expirable

  validates :email, email: { validate_mx: false, allow_idn: false }

  belongs_to :principal, foreign_key: :principal_token

  accepts_nested_attributes_for :principal
end
