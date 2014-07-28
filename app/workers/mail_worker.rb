class MailWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { minutely(10) }

  def perform
    NotificationSample.all.map do |ns|
      ns.unpaid_unsent_instances_until(Time.current)
    end.flatten.each{|x| x.save}
  end
end
