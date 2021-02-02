module AlgoliaIndex
  class Base
    class << self
      def create(*)
        raise NotImplementedError
      end
    end

    def initialize(klass:, id:, firm_id: nil)
      @klass = klass
      @id = id
      @firm_id = firm_id
    end

    def present_in_db?
      if object.respond_to? :publishable?
        object.present? && object.try(:publishable?) && object.try(:hidden_at).nil?
      else
        object.present? && object.try(:hidden_at).nil?
      end
    end

    def update
      raise NotImplementedError
    end
    alias create update

    def destroy
      raise NotImplementedError
    end

    private

    attr_reader :klass, :id, :firm_id

    def object
      @object ||= klass.constantize.find_by(id: id)
    end

    def firm
      if @klass == 'TravelInsuranceFirm' # rubocop:disable Style/ConditionalAssignment
        @firm ||= TravelInsuranceFirm.new(klass: 'TravelInsuranceFirm', id: firm_id || object&.firm_id)
      else
        @firm ||= Firm.new(klass: 'Firm', id: firm_id || object&.firm_id)
      end
    end
  end
end
