module SelfService
  class TradingNameEditPage < FirmEditPage
    set_url '/self_service/trading_names/{trading_name}'
    set_url_matcher %r{/self_service/trading_names/\d+}
  end
end
