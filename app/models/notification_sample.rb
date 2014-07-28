class NotificationSample < ActiveRecord::Base
  belongs_to :notification
  has_many :notification_instances
  has_many :payments, through: :notification
  after_initialize :init

  def init
    self.datetime ||= notification.try(:first_day)
    self.datetime ||= DateTime.parse('2014-07-01')
  end

  def date
    datetime.strftime('%Y-%m-%d')
  end

  def time
    datetime.strftime('%H:%M')
  end

  # format is '2014-05-30'
  def date=(datestr)
    y,m,d = datestr.split('-').map(&:to_i)
    self.datetime = datetime.change(year: y, month: m, day: d)
  end

  # format is '13:42'
  def time=(timestr)
    hh,mm = timestr.split(':').map(&:to_i)
    self.datetime = datetime.change(hour: hh, min: mm, sec: 0)
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
