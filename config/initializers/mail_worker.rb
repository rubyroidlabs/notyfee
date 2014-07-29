if $0.match /unicorn/
  Thread.new do
    puts "Started mail worker inside '#{$0}'"
    loop do
      sleep 5*60
      NotificationSample.all.map do |ns|
        ns.unpaid_unsent_instances_until(Time.current)
      end.flatten.each{|x| x.save }
    end
  end
end
