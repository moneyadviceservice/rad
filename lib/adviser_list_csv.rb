class AdviserListCsv
  def initialize(advisers)
    @lookup = AdviserCsvLookup.new(advisers)
  end

  def to_csv(_ = {})
    CSV.generate do |csv|
      csv << headings
      @lookup.each do |adviser_data|
        csv << row(**adviser_data)
      end
    end
  end

  private

  def headings
    ['Ref. Number', 'Name', 'Firm'] + all_certifications
  end

  def row(adviser:, firm_name:, qualifications:, accreditations:)
    [
      adviser.reference_number,
      adviser.name,
      firm_name
    ] + certified(qualifications, accreditations)
  end

  def certified(qualifications, accreditations)
    adviser_certs = qualifications + accreditations

    all_certifications.map do |certification|
      adviser_certs.include?(certification) ? 'Y' : 'N'
    end
  end

  def all_certifications
    @all_certifications ||= @lookup.certification_list
  end
end
