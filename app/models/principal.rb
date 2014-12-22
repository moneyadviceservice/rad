class Principal < ActiveRecord::Base
  before_create :generate_token

  def self.authenticate(token)
    principal = self.find_by(token: token)
    if principal
      principal.touch(:last_sign_in_at)
      yield(principal)
      principal
    end
  end

  private

  def generate_token
    self.token = SecureRandom.hex
  end
end
