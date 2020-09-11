namespace :index do
  desc '(Re-)index a few dummy Firm\'s advisers and offices'
  task dummy: :environment do
    raise 'Can run this in test only.' unless Rails.env.test?

    Rails.logger.info 'Building a dummy test index...'

    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.cleaning do
      load Rails.root.join('db', 'seeds.rb')
      AlgoliaIndex::TestSeeds.new.generate
    end

    Rails.logger.info 'Index built successfully'
  end

  desc '(Re-)index all existing Firm\'s advisers and offices'
  task all: :environment do
    no_geoloc = lambda { |a| a.latitude.blank? || a.longitude.blank? }

    Rails.logger.info 'Querying the db (this might take some time...)'

    advisers = Firm.onboarded
                   .approved
                   .includes(:advisers)
                   .map(&:advisers)
                   .flatten
                   .reject(&no_geoloc)

    offices = Firm.onboarded
                  .approved
                  .includes(:offices)
                  .map(&:offices)
                  .flatten
                  .reject(&no_geoloc)

    Rails.logger.info 'Building a complete production index...'
    Rails.logger.info "(#{advisers.size} advisers and #{offices.size} offices)"

    AlgoliaIndex::Adviser.create(advisers)
    AlgoliaIndex::Office.create(offices)

    Rails.logger.info 'Index built successfully'
  end

  desc '(Re-)index all existing Travel Insurance Firms and their offerings'
  task travel_insurance: :environment do
    Rails.logger.info 'Querying the db (this might take some time...)'

    firms = TravelInsuranceFirm.approved
                               .joins(:office)
                               .includes(:trip_covers, :medical_specialism, :service_detail)

    Rails.logger.info 'Building a complete production index...'
    Rails.logger.info "(#{firms.size} firms)"

    AlgoliaIndex::TravelInsuranceFirm.create(firms)

    Rails.logger.info 'Index built successfully'
  end
end
