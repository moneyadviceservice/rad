class AdviserCsvLookup
  attr_reader :qualifications_lookup, :accreditations_lookup, :firms_lookup

  def initialize(advisers)
    @advisers = advisers
  end

  def build!
    @qualifications_lookup = build_adviser_qualifications
    @accreditations_lookup = build_adviser_accreditations
    @firms_lookup          = build_adviser_firms
  end

  def certification_list
    qualifications.values + accreditations.values
  end

  def each(&block)
    @advisers.each do |adviser|
      adviser_qualifications = qualifications_lookup[adviser.id] || []
      adviser_accreditations = accreditations_lookup[adviser.id] || []
      block.call(
        adviser: adviser,
        firm_name: firms_lookup[adviser.firm_id],
        qualifications: adviser_qualifications,
        accreditations: adviser_accreditations
      )
    end
  end

  private

  def adviser_ids
    @advisers.map(&:id)
  end

  def build_adviser_qualifications
    certs = certification_query('advisers_qualifications', 'qualification')
    aggregate_certificate_names(certs, type: 'qualification')
  end

  def build_adviser_accreditations
    certs = certification_query('accreditations_advisers', 'accreditation')
    aggregate_certificate_names(certs, type: 'accreditation')
  end

  def build_adviser_firms
    Firm.pluck(:id, :registered_name).to_h
  end

  def certification_query(table, key)
    ActiveRecord::Base.connection.execute("
      SELECT adviser_id, #{key}_id
      FROM #{table}
      WHERE adviser_id IN (#{adviser_ids.join(',')})
    ").to_a
  end

  def qualifications
    @qualifications ||= Qualification.pluck(:id, :name).to_h
  end

  def accreditations
    @accreditations ||= Accreditation.pluck(:id, :name).to_h
  end

  def aggregate_certificate_names(adviser_certifications, type:)
    adviser_certifications.each_with_object({}) do |certification, h|
      adviser_id = certification['adviser_id'].to_i
      h[adviser_id] ||= []
      h[adviser_id] << send(type.pluralize)[certification["#{type}_id"].to_i]
    end
  end
end
