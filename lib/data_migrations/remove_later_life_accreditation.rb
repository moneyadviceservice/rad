class RemoveLaterLifeAccreditation
  def run_migration
    Rails.logger.info 'BEGIN Remove Later Life Accreditation'

    remove_accreditation

    Rails.logger.info 'END Remove Later Life Accreditation'
  end

  private

  def remove_accreditation
    accreditation = Accreditation.find_by(id: 2, name: 'Later Life Academy')

    return unless accreditation

    # There should be no advisers with this accreditation, this is just in case one gets added in the meantime
    Adviser.includes(:accreditations).where(accreditations: { id: accreditation.id }).find_each do |adviser|
      adviser.accreditations.delete(accreditation)
    end

    # Remove the accreditation so it's not available for advisers to add it
    accreditation.destroy
  end
end
