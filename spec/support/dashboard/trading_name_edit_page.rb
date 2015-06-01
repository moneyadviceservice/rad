module Dashboard
  class TradingNameEditPage < FirmEditPage
    set_url '/dashboard/trading_names/{trading_name}'
    set_url_matcher %r{/dashboard/trading_names/\d+}
  end
end
