module Cloud
  VERSION='0.1'.freeze
end

Dir[File.join(File.dirname(__FILE__), 'cloud/*')].each { |file| require file }
