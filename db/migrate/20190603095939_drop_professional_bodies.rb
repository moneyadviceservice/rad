class DropProfessionalBodies < ActiveRecord::Migration
  def change
    drop_table :professional_bodies
  end
end
