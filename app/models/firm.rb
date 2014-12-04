class Firm < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :registerable, :timeoutable and :omniauthable
  devise :database_authenticatable, :confirmable, :recoverable,
         :rememberable, :trackable, :validatable
end
