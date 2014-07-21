begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| Pry::Helpers::BaseHelpers.stagger_output("=> #{value.ai}\n", output) }
rescue LoadError => err
  puts "no awesome_print :("
end
