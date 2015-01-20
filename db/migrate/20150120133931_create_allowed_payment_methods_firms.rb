class CreateAllowedPaymentMethodsFirms < ActiveRecord::Migration
  def change
    create_table :allowed_payment_methods_firms, id: false do |t|
      t.belongs_to :firm, index: true
      t.belongs_to :allowed_payment_method
    end


    add_index :allowed_payment_methods_firms, :allowed_payment_method_id,
              name: 'allowed_payment_methods_firms_allowed_payment_method_id'
  end
end
