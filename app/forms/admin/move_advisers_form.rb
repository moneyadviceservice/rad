module Admin
  class MoveAdvisersForm
    include ActiveModel::Model

    attr_accessor :id, :destination_firm_fca_number, :destination_firm_id,
                  :adviser_ids, :validate_destination_firm_fca_number,
                  :validate_destination_firm_id

    validates :adviser_ids, length: { minimum: 1 }
    validate :destination_firm_fca_number_exists,
             if: :validate_destination_firm_fca_number
    validates :destination_firm_id,
              presence: true,
              if: :validate_destination_firm_id

    def adviser_ids=(values)
      # Needed to strip out the ghost value added by the Rails form helper
      @adviser_ids = values.reject(&:blank?)
    end

    def from_firm
      Firm.find(id)
    end

    def destination_firm
      Firm.find(destination_firm_id)
    end

    def advisers_to_move
      Adviser.where(id: adviser_ids).order(:reference_number)
    end

    def subsidiaries
      Firm
        .registered
        .where(fca_number: destination_firm_fca_number)
        .order('LOWER(registered_name)')
    end

    private

    def destination_firm_fca_number_exists
      return if subsidiaries.count > 0

      errors.add(:destination_firm_fca_number,
                 :does_not_exist,
                 fca_number: destination_firm_fca_number)
    end
  end
end
