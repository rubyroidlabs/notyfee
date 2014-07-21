class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.string :name
      t.string :title
      t.string :to
      t.text :text
      t.integer :start_month
      t.integer :start_year
      t.string :timezone

      t.timestamps
    end
  end
end
