require_relative '../data_migrations/merge_ifp_with_cis'
require_relative '../data_migrations/remove_later_life_accreditation'

namespace :data_migration do
  desc 'Migrate any Professional Standings from the Institute of Financial \
  Planning, which has merged with the The Chartered Institute for Securities \
  and Investments'
  task merge_ifp_with_cis: :environment do
    MergeIfpWithCis.new.run_migration
  end

  desc 'Remove Later Life Accreditation and remove the accreditation from any advisers'
  task remove_later_life_accreditation: :environment do
    RemoveLaterLifeAccreditation.new.run_migration
  end
end
