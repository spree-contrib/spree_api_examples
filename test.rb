puts "Running all the tests!"

Dir['examples/**/*.rb'].each do |f|
  require File.expand_path(f)
end

puts "\n"
puts "*" * 50
puts "[MEGA SUCCESS] All tests complete!"
puts "*" * 50