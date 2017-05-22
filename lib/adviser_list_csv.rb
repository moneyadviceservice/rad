class AdviserListCsv
  def initialize(advisers)
    @advisers = advisers
  end

  def to_csv(_ = {})
    CSV.generate do |csv|
      csv << ['Ref. Number', 'Name', 'Firm']

      @advisers.each do |adviser|
        csv << [adviser.reference_number, adviser.name, adviser.firm.registered_name]
      end
    end
  end
end
