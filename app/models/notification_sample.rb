class NotificationSample < ActiveRecord::Base
  belongs_to :notification, inverse_of: :notification_samples
  has_many :notification_instances, dependent: :destroy
  has_many :payments, through: :notification
  after_initialize :init
  DATETIME_FORMAT = '%Y-%m-%dT%H:%M'

  def init
    self.datetime ||= notification.try(:notification_sample_default_datetime)
    # self.datetime ||= DateTime.current
    #   .change(year: 2014, month: 7, day: 1, hour: 15, min: 0, sec: 0)
  end

  def datetime_local
    datetime.in_time_zone(notification.timezone).strftime(DATETIME_FORMAT)
  end

  # format is '2014-05-30T15:00'
  def datetime_local=(datetime_str)
    self.datetime = ActiveSupport::TimeZone.new(notification.timezone).parse(datetime_str)
  end

  def unpaid_unsent_instances_until(date)
    all_offsets = unpaid_offsets_until(date)
    sent_offsets = notification_instances.where(month_offset: all_offsets).pluck(:month_offset)
    unsent_offsets = (all_offsets.to_set - sent_offsets.to_set).to_a
    unsent_offsets.map do |offset|
      NotificationInstance.new(notification_sample: self, month_offset: offset)
    end
  end

  private

  def unpaid_offsets_until(date)
    paid = paid_offsets
    offsets_until(date).delete_if {|x| paid.include? x }
  end

  def paid_offsets
    payments.pluck(:month_offset)
  end

  def offsets_until(datetime)
    instance_dates_with_offsets
      .take_while { |index, dt| dt < datetime }.map(&:first)
  end

  def instance_dates_with_offsets
    Enumerator.new do |yielder|
      month_offset = 0
      loop do
        date = self.datetime + month_offset.months
        month_offset += 1
        yielder << [month_offset, date]
      end
    end
  end
end
