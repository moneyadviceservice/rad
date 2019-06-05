require_relative '../data_migrations/merge_ifp_with_cis'

namespace :data_migration do
  desc 'Migrate any Professional Standings from the Institute of Financial \
  Planning, which has merged with the The Chartered Institute for Securities \
  and Investments'
  task merge_ifp_with_cis: :environment do
    MergeIfpWithCis.new.run_migration
  end
end
