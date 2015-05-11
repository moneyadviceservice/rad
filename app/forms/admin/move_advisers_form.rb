module Admin
  class MoveAdvisersForm
    include ActiveModel::Model

    attr_accessor :id, :to_firm_fca_number, :to_firm_id, :adviser_ids

    validates :adviser_ids, length: { minimum: 1 }

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
  end
end
