class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :recoverable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :principal, foreign_key: :principal_token

  accepts_nested_attributes_for :principal
end
