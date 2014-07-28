class NotificationInstance < ActiveRecord::Base
  belongs_to :notification_sample
  delegate :notification, to: :notification_sample
  before_create :send!

  def send!
    self.sent_at = Time.current
    NotificationMailer.notification(self).deliver
  end
end
