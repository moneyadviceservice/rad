class MakeOfficesPolymorphic
  def run_migration
    Rails.logger.info 'BEGIN Migrating current offices to polymorphic'

    update_offices_with_model_name

    Rails.logger.info 'END Migrating current offices to polymorphic'
  end

  private

  def update_offices_with_model_name
    Office.find_each do |office|
      # rubocop:disable Rails/SkipsModelValidations
      office.update_columns(
        officeable_id: office.firm_id,
        officeable_type: 'Firm'
      )
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
