module Admin
  class MetricsTableRow < SitePrism::Section
    element :view_button, '.t-snapshot-view-button'
  end

  class MetricsIndexPage < SitePrism::Page
    set_url '/admin/reports/metrics'
    set_url_matcher %r{/admin/reports/metrics}

    sections :snapshots, MetricsTableRow, '.t-snapshot-table-row'
  end
end
