module SelfService
  class StatusPresenter
    def initialize(firm)
      @firm = firm
    end

    def overall_status
      @firm.publishable? ? 'published' : 'unpublished'
    end

    def overall_status_icon
      @firm.publishable? ? 'tick' : 'exclamation'
    end
  end
end
