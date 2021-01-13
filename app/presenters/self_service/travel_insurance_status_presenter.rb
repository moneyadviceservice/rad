module SelfService
  class TravelInsuranceStatusPresenter < SimpleDelegator
    include Rails.application.routes.url_helpers
    include ActionView::Helpers::UrlHelper

    def overall_status
      if hidden?
        'hidden'
      elsif approved?
        'published'
      elsif publishable?
        'pending'
      else
        'unpublished'
      end
    end

    def overall_status_icon
      icon_toggle (publishable? || hidden?)
    end

    %w[uk_and_europe worldwide_excluding_us_canada worldwide_including_us_canada].each do |area_covered|
      define_method "#{area_covered}_icon" do
        icon_toggle trip_covers.send(area_covered).any? && trip_covers.send(area_covered).map(&:all_complete?).all?
      end
    end

    %w[uk_and_europe worldwide_excluding_us_canada worldwide_including_us_canada].each do |area_covered|
      define_method "#{area_covered}_background" do
        trip_covers.send(area_covered).present? && trip_covers.send(area_covered).map(&:all_complete?).all? ? 'complete' : 'unpublished'
      end
    end

    def cover_and_service_icon
      icon_toggle cover_and_service_complete?
    end

    def advisers_icon
      icon_toggle advisers?
    end

    def offices_icon
      icon_toggle main_office
    end

    def offices_link(**opts)
      if office.present?
        path = edit_self_service_travel_insurance_firm_office_path(self, office)
        text = I18n.t('self_service.status.edit')
      else
        path = new_self_service_travel_insurance_firm_office_path(self)
        text = I18n.t('self_service.status.add')
      end

      link_to text, path, opts
    end

    def firm_details_link(**opts)
      path = if trading_name?
               edit_self_service_travel_insurance_trading_name_path(self)
             else
               edit_self_service_travel_insurance_firm_path(self)
             end

      label = if onboarded?
                I18n.t('self_service.status.edit')
              else
                I18n.t('self_service.status.add')
              end

      link_to label, path, opts
    end

    def needs_advisers?
      false
    end

    def needs_offices?
      main_office.present?
    end

    private

    def icon_toggle(condition_met)
      condition_met ? 'tick' : 'exclamation'
    end

  end
end
