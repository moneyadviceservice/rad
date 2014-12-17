namespace :import do
  desc 'Imports Firms from the CSV supplied by CSV=(/path/to/csv)'
  task firms: :environment do
    if csv_path = ENV['CSV']
      puts 'Destroying existing Firms...'
      Lookup::Firm.destroy_all
      puts 'Importing Firms, this may take a while...'

      Import::Importer.new(
        csv_path,
        Import::Mappers::FirmMapper.new(Lookup::Firm)
      ).import

      puts 'Done!'
    else
      puts 'Usage: rake import:firms CSV=/path/to/csv.ext'
      abort
    end
  end
end
