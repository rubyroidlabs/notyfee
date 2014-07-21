class Notification < ActiveRecord::Base
  has_many :notification_samples
  has_many :payments
  has_many :notification_instances
end
