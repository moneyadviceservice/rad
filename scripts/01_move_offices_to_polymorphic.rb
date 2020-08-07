class MoveOfficesToPolymorphic
  def self.run
    Office.where(officeable_id: nil, officeable_type: nil).find_each do |office|
      office.update_columns(
        officeable_id: office.firm_id,
        officeable_type: 'Firm'
      )
    end
  end
end

MoveOfficesToPolymorphic.run
