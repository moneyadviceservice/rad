module AlgoliaIndex
  class Base
    class ObjectClassError < StandardError
      def initialize(expected: nil, got: nil)
        message = if expected.nil? || got.nil?
                    'Base class cannot be initialised directly'
                  else
                    "expected: #{expected}, got: #{got}"
                  end
        super(message)
      end
    end

    class << self
      def create!(*)
        raise NotImplementedError
      end
    end

    def initialize(klass:, id:)
      @klass = klass
      @id = id

      validate_init
    end

    def exists?
      object.present?
    end

    def update!
      raise NotImplementedError
    end
    alias create! update!

    def destroy!
      raise NotImplementedError
    end

    private

    attr_reader :klass, :id

    def object
      @object ||= klass.constantize.find_by(id: id)
    end

    def validate_init
      instance_klass = self.class.name.split('::').last
      raise ObjectClassError if instance_klass == 'Base'
      return if instance_klass == klass

      raise ObjectClassError.new(expected: instance_klass, got: klass)
    end
  end
end