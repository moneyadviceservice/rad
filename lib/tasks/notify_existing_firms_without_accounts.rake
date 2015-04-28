
namespace :notify do
  desc 'existing firms need notified to sign up'
  task existing_firms_to_sign_up: :environment do

    class ::Devise::Mailer < Devise.parent_mailer.constantize
      include Devise::Mailers::Helpers

      def setup_password_instructions(record, token, opts={})
        @token = token
        devise_mail(record, :setup_password_instructions, opts)
      end
    end

    class ::User < ActiveRecord::Base
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable

      belongs_to :principal, foreign_key: :principal_token

      accepts_nested_attributes_for :principal

      def send_set_password_instructions
        token = set_reset_password_token
        send_devise_notification(:setup_password_instructions, token, {})

        token
      end
    end


    Principal.all.each do |p|
      user = User.find_by_principal_token p.token

      if user.nil?
        new_user = User.create({
          :principal_token => p.token,
          email: p.email_address,
          password: 'password',
          password_confirmation: 'password'
        })
        new_user.send_set_password_instructions
      end
    end
  end
end
