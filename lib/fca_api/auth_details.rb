module FCA_API
  class AuthDetails
    def domain
      ENV.fetch('FCA_API_AUTH_DOMAIN')
    end

    def path
      'authenticationws/tokens'.freeze
    end

    def username
      ENV.fetch('FCA_API_EMAIL')
    end

    def password
      ENV.fetch('FCA_API_PASSWORD')
    end
  end
end