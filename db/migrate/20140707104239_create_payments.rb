class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :company_id

      t.timestamps
    end
  end
end
