module AdviserCertificationsLookup
  def initialize(adviser_ids)
    @adviser_ids = adviser_ids
  end

  def for(adviser_id)
    lookup[adviser_id] || []
  end

  def query
    ActiveRecord::Base.connection.execute("
      SELECT adviser_id, #{type}_id
      FROM #{table}
      WHERE adviser_id IN (#{@adviser_ids.join(',')})
    ").to_a
  end

  def certifications
    @certifications ||= type.classify.constantize.pluck(:id, :name).to_h
  end

  def all_certifications
    certifications.values
  end

  def lookup
    @lookup ||= query.each_with_object({}) do |certification, h|
      adviser_id = certification['adviser_id'].to_i
      certification_name = certifications[certification["#{type}_id"].to_i]
      h[adviser_id] ||= []
      h[adviser_id] << certification_name
    end
  end
end
