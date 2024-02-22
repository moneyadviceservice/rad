require File.join(Rails.root, 'lib/cloud.rb')

data = if %w(development test).include?(Rails.env)
  YAML.load(ERB.new(File.read(File.join(Rails.root, 'config/cloud_storage.yml'))).result, aliases: true)[Rails.env]
else
  {
    'provider_name'  => 'azure',
    'account_name'   => ENV['AZURE_ACCOUNT'],
    'container_name' => ENV['AZURE_CONTAINER'],
    'shared_key'     => ENV['AZURE_SHARED_KEY'],
    'root'           => Rails.root
  }
end

if data['provider_name'] == 'azure' && (data['account_name'].blank? || data['shared_key'].blank? || data['container_name'].blank?)
  $stdout.puts('-' * 80)
  $stdout.puts("[Warn] - FCA import - When using azure, please make sure the environment variables are set: AZURE_ACCOUNT, AZURE_CONTAINER, AZURE_SHARED_KEY.")
  $stdout.puts('-' * 80)
end

Cloud::Storage.configure do |config|
  config.provider_name  = data['provider_name']
  config.account_name   = data['account_name']
  config.container_name = data['container_name']
  config.shared_key     = data['shared_key']
  config.root           = data['root']
end
