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

  def notification_samples_for_form
    collection = notification_samples.where(notification_id: id)
    collection.any? ? collection : notification_samples.build
  end

  def css_class
    (notification_samples.count == 1) ? 'good' : ''
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
    (0...12).map do |month|
      offset = offsets[month]
      instance_count = notification_instances.where(month_offset: offset).count
      {
        offset: offset,
        css_classes: css_row_classes(year, month, offset, instance_count, ns_count),
        count: instance_count
      }
    end
  end

  def errors_flash_content
    h.content_tag :ul, class: 'error_list' do
      errors.full_messages.each do |msg|
        h.concat(h.content_tag(:li, msg))
      end
    end
  end

  def css_row_classes(year, month, offset, instance_count, ns_count)
    [].tap do |classes|
      classes << 'paid' if payments.where(month_offset: offset).any?
      classes << 'max'  if (instance_count == ns_count)
      classes << 'empty' if offset < 0
      classes << 'future' unless DateTime.parse("#{year}-#{month+1}-01") < Time.current
    end.join " "
  end
end
