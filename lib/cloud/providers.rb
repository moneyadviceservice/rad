Dir[File.join(File.dirname(__FILE__), 'providers/*.rb')].each do |file|
  require file
end
