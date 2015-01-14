namespace :import do
  desc 'Imports Advisers from the CSV supplied by CSV=(/path/to/csv)'
  task advisers: :environment do
    if csv_path = ENV['CSV']
      puts 'Destroying existing Advisers...'
      Lookup::Adviser.destroy_all
      puts 'Importing Advisers, this may take a while...'

      Import::Importer.new(
        csv_path,
        Import::Mappers::AdviserMapper.new(Lookup::Adviser)
      ).import

      puts 'Done!'
    else
      puts 'Usage: rake import:advisers CSV=/path/to/csv.ext'
      abort
    end
  end

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

  desc 'Imports Subsidiaries from the CSV supplied by CSV=(/path/to/csv)'
  task subsidiaries: :environment do
    if csv_path = ENV['CSV']
      puts 'Destroying existing Subsidiaries...'
      Lookup::Subsidiary.destroy_all
      puts 'Importing Subsidiaries, this may take a while...'

      Import::Importer.new(
        csv_path,
        Import::Mappers::SubsidiaryMapper.new(Lookup::Subsidiary)
      ).import

      puts 'Done!'
    else
      puts 'Usage: rake import:subsidiaries CSV=/path/to/csv.ext'
      abort
    end
  end
end
