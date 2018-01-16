module Cloud
  class Config
    attr_accessor :provider_name,
                  :account_name,
                  :container_name,
                  :shared_key,
                  :root

    def settings
      {
        account_name:   account_name,
        container_name: container_name,
        shared_key:     shared_key,
        root:           root
      }
    end
  end
end
