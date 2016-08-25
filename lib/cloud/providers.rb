Dir[File.join(File.dirname(__FILE__), 'providers/*.rb')].each { |file| require file }
