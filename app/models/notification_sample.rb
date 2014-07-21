class NotificationSample < ActiveRecord::Base
  belongs_to :notification
  has_many :notification_instances
end
