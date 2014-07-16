Dir['examples/**/*.rb'].each do |f|
  require File.expand_path(f)
end

puts "\n"
puts ("*" * 50).green
puts "[MEGA SUCCESS] All tests complete!".green
puts ("*" * 50).green
