require File.join(Rails.root, 'lib/cloud.rb')

data = YAML.load(ERB.new(File.read(File.join(Rails.root, 'config/cloud_storage.yml'))).result)[Rails.env]

Cloud::Storage.configure do |config|
  config.provider_name  = data['provider_name']
  config.account_name   = data['account_name']
  config.container_name = data['container_name']
  config.shared_key     = data['shared_key']
  config.root           = data['root']
end
