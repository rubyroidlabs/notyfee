class Notification < ActiveRecord::Base
  has_many :notification_samples
  has_many :payments
  has_many :notification_instances, through: :notification_samples

  def check_and_send
    notification_samples.each(&:check_and_send)
  end
end
