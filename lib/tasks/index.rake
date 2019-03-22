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
  namespace :algolia do
    task :seed => :environment do
      raise 'Can run this in test only.' unless Rails.env.test?

      DatabaseCleaner.clean_with :truncation
      DatabaseCleaner.cleaning do
        load Rails.root.join('db', 'seeds', 'algolia.rb')
        Seeds::Algolia.new.generate
      end
    end
   end

  task create: :environment do
    desc 'Index all existing Firm\'s advisers'
    no_geoloc = lambda { |a| a.latitude.blank? || a.longitude.blank? }
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

    AlgoliaIndex::Adviser.create!(advisers)
    AlgoliaIndex::Office.create!(offices)
  end
end
