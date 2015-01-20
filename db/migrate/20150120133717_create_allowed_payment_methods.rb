class CreateAllowedPaymentMethods < ActiveRecord::Migration
  def change
    create_table :allowed_payment_methods do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
