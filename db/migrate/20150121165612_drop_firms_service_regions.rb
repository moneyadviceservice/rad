class DropFirmsServiceRegions < ActiveRecord::Migration
  def change
    drop_table :firms_service_regions
  end
end
