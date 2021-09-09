class AddIndividualReferenceNumberToPrincipals < ActiveRecord::Migration[5.2]
  def change
    add_column :principals, :individual_reference_number, :string, null: false, default: ''
  end
end
