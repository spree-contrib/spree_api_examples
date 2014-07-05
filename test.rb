puts "Running json tests!"

Dir['json_examples/**/*.rb'].each do |f|
  require File.expand_path(f)
end

puts "Running parameter tests!"

Dir['parameter_examples/**/*.rb'].each do |f|
  require File.expand_path(f)
end

puts "\n"
puts "*" * 50
puts "[MEGA SUCCESS] All tests complete!"
puts "*" * 50
