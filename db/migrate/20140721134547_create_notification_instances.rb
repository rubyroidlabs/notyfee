class CreateNotificationInstances < ActiveRecord::Migration
  def change
    create_table :notification_instances do |t|
      t.references :notification_sample, index: true
      t.integer :month
      t.integer :year
      t.datetime :sent_at

      t.timestamps
    end
  end
end
