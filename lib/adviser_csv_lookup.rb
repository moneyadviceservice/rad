class AdviserCsvLookup
  def initialize(advisers)
    @advisers = advisers
  end

  def certification_list
    all_qualifications + all_accreditations
  end

  def each
    @advisers.each do |adviser|
      adviser_qualifications = qualifications_lookup.for(adviser.id)
      adviser_accreditations = accreditations_lookup.for(adviser.id)
      yield(adviser: adviser,
            firm_name: firms_lookup[adviser.firm_id],
            qualifications: adviser_qualifications,
            accreditations: adviser_accreditations)
    end
  end

  def qualifications_lookup
    @qualifications_lookup ||= AdviserQualificationsLookup.new(adviser_ids)
  end

  def accreditations_lookup
    @accreditations_lookup ||= AdviserAccreditationsLookup.new(adviser_ids)
  end

  def firms_lookup
    @firms_lookup ||= Firm.pluck(:id, :registered_name).to_h
  end

  private

  def adviser_ids
    @advisers.map(&:id)
  end

  def all_qualifications
    qualifications_lookup.all_certifications
  end

  def all_accreditations
    accreditations_lookup.all_certifications
  end
end
