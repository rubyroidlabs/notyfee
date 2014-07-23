# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

n1 = Notification.where(
  name: 'Tesla Motors',
  title: 'Please pay',
  to: 'teslamotors@example.com',
  text: 'Kind payment reminder',
  start_year: 2014,
  start_month: 3,
  timezone: 'GMT').first_or_create

n2 = Notification.where(
  name: 'Canonical',
  title: 'Please pay us',
  to: 'canonical@example.com',
  text: 'Some text here',
  start_year: 2014,
  start_month: 5,
  timezone: 'PDT').first_or_create

['2014-02-25 15:00', '2014-02-28 15:00', '2014-03-05'].each do |date_str|
  ns = NotificationSample.where(
    notification: n1,
    datetime: DateTime.parse(date_str)
    ).first_or_create
  10.times do |offset|
    NotificationInstance.where(
      notification_sample: ns,
      month_offset: offset
      ).first_or_create if [true, true, false].sample
  end
end

['2014-04-24 15:00', '2014-04-29 15:00', '2014-05-05'].each do |date_str|
  ns = NotificationSample.where(
    notification: n2,
    datetime: DateTime.parse(date_str)
    ).first_or_create
  10.times do |offset|
    NotificationInstance.where(
      notification_sample: ns,
      month_offset: offset
      ).first_or_create if [true, true, false].sample
  end
end
