class NotificationDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def good?
    notification_sample.count == 1
  end

  def offsets_for_year(year)
    start = start_year * 12 + start_month
    (1..12).map do |month|
      year * 12 + month - start
    end
  end

  def row_data(year)
    offsets = offsets_for_year(year)
    ns_count = notification_samples.count
    (0...12).map do |x|
      offset = offsets[x]
      instance_count = notification_instances.where(month_offset: offset).count
      {
        offset: offset,
        paid: payments.where(month_offset: offset).any?,
        count: instance_count,
        max: (instance_count == ns_count),
      }
    end
  end
end
