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
      object.present? && object.visible_in_directory?
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
      # rubocop:disable Style/ConditionalAssignment
      if @klass == 'TravelInsuranceFirm'
        @firm ||= TravelInsuranceFirm.new(klass: 'TravelInsuranceFirm', id: id)
      else
        @firm ||= Firm.new(klass: 'Firm', id: firm_id || object&.firm_id)
      end
      # rubocop:enable Style/ConditionalAssignment
    end

    def trip_covers
      return nil unless @klass == 'TravelInsuranceFirm'

      @trip_covers ||= TripCover.where(travel_insurance_firm_id: id || object&.firm_id)
    end
  end
end
