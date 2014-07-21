class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :notification, index: true
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
