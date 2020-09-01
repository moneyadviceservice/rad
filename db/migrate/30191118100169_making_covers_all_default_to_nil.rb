class MakingCoversAllDefaultToNil < ActiveRecord::Migration[5.2]
  def change
    change_column :medical_specialisms, :specialised_medical_conditions_covers_all, :boolean, default: nil
  end
end
