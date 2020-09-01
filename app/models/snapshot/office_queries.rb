module Snapshot::OfficeQueries
  def query_offices_with_disabled_access
    firm_ids = publishable_firms.map(&:id)
    Office.includes(:officeable).where(disabled_access: true, officeable_id: firm_ids, officeable_type: 'Firm')
  end
end
