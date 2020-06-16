class MakingOfficesPolymorphic < ActiveRecord::Migration[5.2]
  def change
    add_reference :offices, :officeable, polymorphic: true, index: true
    change_column_null :offices, :firm_id, true
  end
end
