class User < ActiveRecord::Base
  include ActiveModel::Dirty

  devise :invitable, :database_authenticatable, :recoverable,
         :recoverable, :rememberable, :trackable, :registerable,
         :secure_validatable, :password_archivable, :password_expirable

  belongs_to :principal, foreign_key: :principal_token

  accepts_nested_attributes_for :principal
end
