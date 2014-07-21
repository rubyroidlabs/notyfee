class CreateNotificationSamples < ActiveRecord::Migration
  def change
    create_table :notification_samples do |t|
      t.references :notification, index: true
      t.datetime :datetime

      t.timestamps
    end
  end
end
