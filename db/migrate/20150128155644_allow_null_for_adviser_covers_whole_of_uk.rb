class AllowNullForAdviserCoversWholeOfUk < ActiveRecord::Migration
  def change
    change_column :advisers, :covers_whole_of_uk, :boolean, null: true, default: nil
  end
end
