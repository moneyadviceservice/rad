module SelfService
  module TravelInsuranceFirms
    class IndexPage < SitePrism::Page
      set_url '/self_service/travel_insurance_firms'
      set_url_matcher %r{/self_service/travel_insurance_firms}

      element :flash_message, '.t-flash-message'
      element :page_title, '.t-page-title'
      element :parent_firm_heading, '.t-parent-firm-heading'
      section :parent_firm, FirmTableRowSection, '.t-parent-firm-table-row'
      element :trading_names_block, '.t-trading-names-block'
      element :add_trading_names_prompt, '.t-add-trading-names-prompt'
      sections :trading_names, FirmTableRowSection, '.t-trading-name-table-row'
      element :available_trading_names_block, '.t-available-trading-names-block'
      sections :available_trading_names, FirmTableRowSection, '.t-available-trading-name-table-row'
      section :navigation, NavigationSection, '.t-navigation'
      element :onboarding_message, '.t-onboarding-message'

      element :add_office_link, '.t-office-link'
      element :cover_and_service_link, '.t-cover-and-service-link'

      element :reregistration_banner, '.t-reregistration-banner'
    end
  end
end
