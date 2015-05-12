module Admin
  class MoveAdvisersForm
    include ActiveModel::Model

    attr_accessor :id, :to_firm_fca_number, :to_firm_id, :adviser_ids, :validate_to_firm_fca_number, :validate_to_firm_id

    validates :adviser_ids, length: { minimum: 1 }
    validate :to_firm_fca_number_exists, if: :validate_to_firm_fca_number
    validates :to_firm_id, presence: true, if: :validate_to_firm_id

    def adviser_ids=(values)
      # Needed to strip out the ghost value added by the Rails form helper
      @adviser_ids = values.reject(&:blank?)
    end

    def from_firm
      Firm.find(id)
    end

    def to_firm
      Firm.find(to_firm_id)
    end

    def advisers_to_move
      Adviser.where(id: adviser_ids)
    end

    def subsidiaries
      Firm.registered.where(fca_number: to_firm_fca_number).order('LOWER(registered_name)')
    end

    private

    def to_firm_fca_number_exists
      unless Firm.where(fca_number: to_firm_fca_number).count > 0
        errors.add(:fca_number, "No firms exist with FCA number #{to_firm_fca_number}")
      end
    end
  end
end
