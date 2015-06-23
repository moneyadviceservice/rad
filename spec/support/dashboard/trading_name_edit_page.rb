module SelfService
  class TradingNameEditPage < FirmEditPage
    set_url '/selfservice/trading_names/{trading_name}'
    set_url_matcher %r{/selfservice/trading_names/\d+}
  end
end
