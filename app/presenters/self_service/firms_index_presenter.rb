module SelfService
  FirmsIndexPresenter = Struct.new(:firm, :trading_names, :lookup_names) do
    def firm_has_trading_names?
      trading_names.present? || lookup_names.present?
    end

    def total_firms
      1 + trading_names.count + lookup_names.count
    end

    def no_trading_names_have_been_added?
      trading_names.empty?
    end

    def trading_names_are_available_to_add?
      lookup_names.present?
    end

    def requires_reregistration?
      !firm.reregistered_at?
    end
  end
end
