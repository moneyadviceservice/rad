module Admin
  class MetricsShowPage < SitePrism::Page
    set_url '/admin/reports/metrics/{snapshot_id}'
    set_url_matcher %r{/admin/reports/metrics/[0-9]+}

    element :table, '.t-table'
  end
end
