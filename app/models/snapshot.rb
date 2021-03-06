class Snapshot < ApplicationRecord
  include Snapshot::MetricsInOrder
  include Snapshot::AdviserQueries
  include Snapshot::FirmQueries
  include Snapshot::OfficeQueries

  def run_queries_and_save
    run_queries
    save
  end

  private

  def publishable_firms
    # REVIEW: SHOULD BE ALTERED TO Firm.visible_in_directory?
    @_publishable_firms ||= Firm.onboarded.select(&:publishable?)
  end

  # 1. Gets all metric fields
  # 2. For each of those, find the related query
  # 3. Run the query method, count the return value, and set the metric
  def run_queries
    metrics_in_order.each do |metric|
      query_method = "query_#{metric}"
      result = send(query_method)
      self[metric] = result.count
    end
  end
end
