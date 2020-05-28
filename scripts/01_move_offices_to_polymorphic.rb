class MoveOfficesToPolymorphic
  def self.run
    Office.find_each do |office|
      office.update_columns(
        officeable_id: office.firm_id,
        officeable_type: 'Firm'
      )
    end
  end
end

MoveOfficesToPolymorphic.run
