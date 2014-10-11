#!/usr/bin/env ruby

def f2(s)
  result = ("%.2f" % s).to_s
  result += '0' if result.end_with?('.0')
  result
end

def left_align(width,number)
  number.to_s + " " * (width - number.to_s.length)
end

def right_align(width,number)
  " " * (width - number.to_s.length) + number.to_s
end

def print_heading
  print  left_align(15,'')
  print right_align( 5,'#t')        # number of tests
  print right_align( 7,'#ass')      # number of assertions
  print right_align( 3,'#f')        # number of failures
  print right_align( 3,'#e')        # number of errors
  print right_align( 3,'#s')        # number of skips
  print right_align( 9,'took(s)')   # time in seconds
  print right_align( 9,'t/s')       # tests per second
  print right_align( 9,'ass/s')     # assertions per second
  print right_align( 9,'cov(%)')    # coverage
  puts
end

stats = { }
modules = %w( app_helpers app_lib app_models lib languages integration app_controllers )
modules.each do |mod|

  log = `cat #{mod}/log.tmp`
  h = stats[mod] = { }

  # Finished tests in 0.083102s, 132.3675 tests/s, 348.9687 assertions/s.
  tally = '([\.|\d]+)'
  pattern = 'Finished tests in ' + tally + 's, '+
             tally + ' tests/s, ' +
             tally + ' assertions/s'
  m = log.match(Regexp.new(pattern))
  h[:took] = f2(m[1])
  h[:tests_per_sec] = f2(m[2])
  h[:assertions_per_sec] = f2(m[3])

  # 11 tests, 29 assertions, 0 failures, 0 errors, 0 skips
  words = %w( tests assertions failures errors skips)
  pattern = words.map{ |s| tally + ' ' + s }.join(', ')
  m = log.match(Regexp.new(pattern))
  h[:test_count] = m[1].to_i
  h[:assertion_count] = m[2].to_i
  h[:failure_count] = m[3].to_i
  h[:error_count] = m[4].to_i
  h[:skip_count] = m[5].to_i

  # Coverage = 100.0%
  pattern = 'Coverage = ' + tally + '%'
  m = log.match(Regexp.new(pattern))
  h[:coverage] = f2(m[1])

end



puts
print_heading
puts '-' * 75

modules.each do |mod|
  h = stats[mod]
  print  left_align(15,mod)
  print right_align( 5,h[:test_count])
  print right_align( 7,h[:assertion_count])
  print right_align( 3,h[:failure_count])
  print right_align( 3,h[:error_count])
  print right_align( 3,h[:skip_count])
  print right_align( 9,h[:took])
  print right_align( 9,h[:tests_per_sec])
  print right_align( 9,h[:assertions_per_sec])
  print right_align( 9,h[:coverage])
  puts
end

puts '- ' * 38
print  left_align(15,'total')
print right_align( 5,    c=stats.map{|_,h| h[:test_count].to_i}.reduce(:+))
print right_align( 7,    a=stats.map{|_,h| h[:assertion_count].to_i}.reduce(:+))
print right_align( 3,      stats.map{|_,h| h[:failure_count]}.reduce(:+))
print right_align( 3,      stats.map{|_,h| h[:error_count]}.reduce(:+))
print right_align( 3,      stats.map{|_,h| h[:skip_count]}.reduce(:+))
print right_align( 9, t=f2(stats.map{|_,h| h[:took].to_f}.reduce(:+)))
print right_align( 9, f2(c / t.to_f))
print right_align( 9, f2(a / t.to_f))
puts
puts '-' * 75
