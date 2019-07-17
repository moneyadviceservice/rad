class AddMissingGeolocationToOffices < ActiveRecord::Migration
  def up
    Office
      .where(id: [302, 854, 1279, 1302, 2461, 2607, 2635])
      .each(&:save_with_geocoding)
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
