class AddNewAttributesToOfferings
  def run_migration
    Rails.logger.info 'BEGIN Migrating new attributes to Algolia'

    update_algolia_offerings

    Rails.logger.info 'END Migrating new attributes to Algolia'
  end

  private

  def update_algolia_offerings
    TripCover.all.each do |tc|
      tc.land_50_days_max_age = tc.land_45_days_max_age
      tc.cruise_50_days_max_age = tc.cruise_45_days_max_age
      tc.save
    end

    TravelInsuranceFirm.all.each do |object|
      if object.visible_in_directory?
        tc = object.trip_covers.map(&AlgoliaIndex::TravelInsuranceFirmOfferingSerializer.method(:new))
        AlgoliaIndex.indexed_travel_insurance_firm_offerings.add_objects(tc)
      end
    end
  end
end
