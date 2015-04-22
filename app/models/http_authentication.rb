module HttpAuthentication
  class << self
    def required?
      true#Rails.env.production?
    end

    def username
      # ENV['AUTH_USERNAME']
      'user'
    end

    def password
      # ENV['AUTH_PASSWORD']
      'pass'
    end

    def authenticate(username, password)
      self.username == username && self.password == password
    end
  end
end
