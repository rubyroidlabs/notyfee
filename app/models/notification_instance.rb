class NotificationInstance < ActiveRecord::Base
  belongs_to :notification_sample
  delegate :notification, to: :notification_sample
end
