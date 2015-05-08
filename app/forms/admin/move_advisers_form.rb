module Admin
  class MoveAdvisersForm
    include ActiveModel::Model

    attr_accessor :id, :to_firm_fca_number, :to_firm_id, :adviser_ids

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
