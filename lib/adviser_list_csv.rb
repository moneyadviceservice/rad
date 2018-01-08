class AdviserListCsv
  def initialize(advisers)
    @advisers = advisers
  end

  def to_csv(_ = {})
    CSV.generate do |csv|
      csv << headings
      @advisers.each do |adviser|
        csv << row(adviser)
      end
    end
  end

  private

  def headings
    ['Ref. Number', 'Name', 'Firm'] + all_certifications
  end

  def row(adviser)
    [
      adviser.reference_number,
      adviser.name,
      adviser.firm.registered_name
    ] + certified(adviser)
  end

  def all_certifications
    @certifications ||= Accreditation.pluck(:name) + Qualification.pluck(:name)
  end

  def certified(adviser)
    all_certifications.map do |certification|
      certifications_for(adviser).include?(certification) ? 'Y' : 'N'
    end
  end

  def certifications_for(adviser)
    adviser.accreditations.pluck(:name) + adviser.qualifications.pluck(:name)
  end
end
