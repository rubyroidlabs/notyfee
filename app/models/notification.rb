class Notification < ActiveRecord::Base
  has_many :notification_samples
  has_many :payments
  has_many :notification_instances, through: :notification_samples
  after_initialize :init
  accepts_nested_attributes_for :notification_samples
  %i(name title to text start_month start_year notification_samples timezone).each do |x|
    validates x, presence: true
  end

  def init
    time = Time.current
    self.start_year  ||= time.year
    self.start_month ||= time.month
    self.timezone    ||= 'UTC'
  end

  def check_and_send
    notification_samples.each(&:check_and_send)
  end

  def year_month
    "#{start_year}-#{start_month.to_s.rjust(2,'0')}"
  end

  def year_month=(data)
    self.start_year, self.start_month = data.split('-')
  end

  def first_day
    DateTime.parse first_day_str
  end

  def first_day_str
    "#{start_year}-#{start_month}-01"
  end
end
