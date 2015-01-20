class CreateFirmsServiceRegions < ActiveRecord::Migration
  def change
    create_table :firms_service_regions, id: false do |t|
      t.belongs_to :firm, index: true
      t.belongs_to :service_region, index: true
    end
  end
end
