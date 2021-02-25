require_relative '../data_migrations/merge_ifp_with_cis'
require_relative '../data_migrations/make_offices_polymorphic'
require_relative '../data_migrations/remove_later_life_accreditation'
require_relative '../data_migrations/add_new_attributes_to_offerings'

namespace :data_migration do
  desc 'Migrate any Professional Standings from the Institute of Financial \
  Planning, which has merged with the The Chartered Institute for Securities \
  and Investments'
  task merge_ifp_with_cis: :environment do
    MergeIfpWithCis.new.run_migration
  end

  desc 'Updates Offices with the appropriate model name as part of migrating to polymorphic'
  task make_offices_polymorphic: :environment do
    MakeOfficesPolymorphic.new.run_migration
  end

  desc 'Remove Later Life Accreditation and remove the accreditation from any advisers'
  task remove_later_life_accreditation: :environment do
    RemoveLaterLifeAccreditation.new.run_migration
  end

  desc 'Add New Attributes for 1 - 3 Month Trip Duration To Offerings'
  task add_new_attributes_to_offerings: :environment do
    AddNewAttributesToOfferings.new.run_migration
  end
end
