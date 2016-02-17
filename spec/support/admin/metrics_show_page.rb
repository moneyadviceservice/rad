module Admin
  class MetricsShowPage < SitePrism::Page
    set_url '/admin/metrics/{snapshot_id}'
    set_url_matcher %r{/admin/metrics/[0-9]+}

    element :table, '.t-table'
  end
end
