namespace :data do
  namespace :migrate do
    def change_type(record)
      if record.new_record?
        '+ Adding   '
      elsif record.name_changed?
        '! Changing '
      else
        '  No change'
      end
    end

    desc 'Migrate qualifications data in an existing database'
    task qualifications: :environment do
      # This is a snapshot of the seed data at the time this task was written
      seed_data_snapshot = {
        # We lookup each by the 'order' attribute rather than id, as this field
        # is guaranteed to be consistent because it is used to map to translations
        # in rad_consumer
        1 => 'Level 4 (DipPFS, DipFA® or equivalent)',
        2 => 'Level 6 (APFS, Adv DipFA®)',
        3 => 'Chartered Financial Planner',
        4 => 'Certified Financial Planner',
        5 => 'Pension transfer qualifications - holder of G60, AF3, AwPETR®, or equivalent',
        6 => 'Equity release qualifications i.e. holder of Certificate in Equity Release or equivalent',
        7 => 'Long term care planning qualifications i.e. holder of CF8, CeLTCI®. or equivalent',
        8 => 'Holder of Trust and Estate Practitioner qualification (TEP) i.e. full member of STEP',
        9 => 'Fellow of the Chartered Insurance Institute (FCII)'
      }

      Qualification.transaction do
        seed_data_snapshot.each do |ordinal, name|
          q = Qualification.find_or_initialize_by(order: ordinal)
          q.name = name
          puts "#{change_type(q)} #{ordinal} => #{name}"
          q.save!
        end
      end

      puts 'Done.'
    end
  end
end
