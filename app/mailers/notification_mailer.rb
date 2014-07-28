class NotificationMailer < ActionMailer::Base
  default from: "rubyroidlabs@gmail.com"

  def notification(notification_instance)
    @notification = notification_instance.notification
    mail(to: @notification.to, subject: @notification.title)
  end
end
