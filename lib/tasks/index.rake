namespace :firms do
  desc 'Index all existing firms'
  task index: :environment do
    puts "Do you want to index all #{Firm.registered.count} indexable firms? [type `yes` to confirm]"
    confirmation = STDIN.gets.chomp

    if confirmation.downcase == 'yes'
      print 'Building firms index: '

      Firm.registered.each do |f|
        f.notify_indexer
        putc '.'
      end

      puts
      puts 'Indexing done.'
    else
      puts 'Indexing aborted.'
    end
  end
end

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

    advisers = Firm.registered
                   .includes(:advisers)
                   .map(&:advisers)
                   .flatten
                   .reject(&no_geoloc)

    offices = Firm.registered
                  .includes(:offices)
                  .map(&:offices)
                  .flatten
                  .reject(&no_geoloc)

    Rails.logger.info 'Building a complete production index...'
    Rails.logger.info "(#{advisers.size} advisers and #{offices.size} offices)"

    AlgoliaIndex::Adviser.create!(advisers)
    AlgoliaIndex::Office.create!(offices)

    Rails.logger.info 'Index built successfully'
  end
end
