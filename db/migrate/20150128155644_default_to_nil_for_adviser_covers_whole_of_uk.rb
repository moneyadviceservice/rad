class DefaultToNilForAdviserCoversWholeOfUk < ActiveRecord::Migration
  def up
    change_column :advisers, :covers_whole_of_uk, :boolean, default: nil
  end

  def down
    change_column :advisers, :covers_whole_of_uk, :boolean, default: false
  end
end
