require_relative '../data_migrations/merge_ifp_with_cis'
require_relative '../data_migrations/make_offices_polymorphic'

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
end
