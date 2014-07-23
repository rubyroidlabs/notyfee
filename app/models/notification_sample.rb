class NotificationSample < ActiveRecord::Base
  belongs_to :notification
  has_many :notification_instances
  has_many :payments, through: :notification

  def unpaid_instances_until(date)
    unpaid_offsets_until(date).map do |offset|
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
