require 'forwardable'

module River
  class Context < Hash
    extend Forwardable

    attr_accessor :writer

    def_delegators :writer, :write
  end
end
