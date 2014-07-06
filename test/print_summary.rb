#!/usr/bin/env ruby

def f2(s)
  result = ("%.2f" % s).to_s
  result += '0' if result.end_with?('.0')
  result
end

def la(width,d)
  d.to_s + " " * (width - d.to_s.length)
end

def ra(width,d)
  " " * (width - d.to_s.length) + d.to_s
end

def print_heading
  print la(15,'')
  print ra(5,'#t')
  print ra(7,'#ass')
  print ra(3,'#f')
  print ra(3,'#e')
  print ra(3,'#s')
  print ra(9,'took(s)')
  print ra(9,'t/s')
  print ra(9,'ass/s')
  print ra(9,'cov(%)')
  puts
end

stats = { }
modules = %w( app_helpers app_lib app_models lib integration app_controllers )
modules.each do |mod|

  h = stats[mod] = { }

  timings  = `tail -5 #{mod}/log.tmp | head -1`
  counts   = `tail -3 #{mod}/log.tmp | head -1`
  coverage = `tail -1 #{mod}/log.tmp`

  # Finished tests in 0.083102s, 132.3675 tests/s, 348.9687 assertions/s.
  pattern = /Finished tests in ([\.|\d]+)s, ([\.|\d]+) tests\/s, ([\.|\d]+) assertions\/s/
  m = timings.match(pattern)
  h[:took] = f2(m[1])
  h[:tests_per_sec] = f2(m[2])
  h[:assertions_per_sec] = f2(m[3])

  # 11 tests, 29 assertions, 0 failures, 0 errors, 0 skips
  pattern = /([\.|\d]+) tests, ([\.|\d]+) assertions, ([\.|\d]+) failures, ([\.|\d]+) errors, ([\.|\d]+) skips/
  m = counts.match(pattern)
  h[:test_count] = m[1].to_i
  h[:assertion_count] = m[2].to_i
  h[:failure_count] = m[3].to_i
  h[:error_count] = m[4].to_i
  h[:skip_count] = m[5].to_i

  # Coverage = 100.0%
  pattern = /Coverage = ([\.|\d]+)%/
  m = coverage.match(pattern)
  h[:coverage] = f2(m[1])

end



puts
print_heading
puts '-' * 75

modules.each do |mod|
  h = stats[mod]
  print la(15,mod)
  print ra(5,h[:test_count])
  print ra(7,h[:assertion_count])
  print ra(3,h[:failure_count])
  print ra(3,h[:error_count])
  print ra(3,h[:skip_count])
  print ra(9,h[:took])
  print ra(9,h[:tests_per_sec])
  print ra(9,h[:assertions_per_sec])
  print ra(9,h[:coverage])
  puts
end

puts '- ' * 38
print la(15,'total')
print ra(5, c=stats.map{|_,h| h[:test_count].to_i}.reduce(:+))
print ra(7, a=stats.map{|_,h| h[:assertion_count].to_i}.reduce(:+))
print ra(3, stats.map{|_,h| h[:failure_count]}.reduce(:+))
print ra(3, stats.map{|_,h| h[:error_count]}.reduce(:+))
print ra(3, stats.map{|_,h| h[:skip_count]}.reduce(:+))
print ra(9, t=f2(stats.map{|_,h| h[:took].to_f}.reduce(:+)))
print ra(9, f2(c/t.to_f))
print ra(9, f2(a/t.to_f))

puts
puts '-' * 75
