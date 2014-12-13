#!/usr/bin/env ruby

def f2(s)
  result = ("%.2f" % s).to_s
  result += '0' if result.end_with?('.0')
  result
end

def padded(width,it)
  " " * (width - it.to_s.length)
end

def print_left(width,it)
  print it.to_s + padded(width,it)
end

def print_right(width,it)
  print padded(width,it) + it.to_s
end

def modules
  %w( app_helpers app_lib app_models lib languages integration app_controllers )
end

def gather_stats
  stats = { }
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
  stats
end

def print_heading
  puts
  print_left(15,'')
  print_right( 5,'#t')        # number of tests
  print_right( 7,'#ass')      # number of assertions
  print_right( 3,'#f')        # number of failures
  print_right( 3,'#e')        # number of errors
  print_right( 3,'#s')        # number of skips
  print_right( 9,'took(s)')   # time in seconds
  print_right( 9,'t/s')       # tests per second
  print_right( 9,'ass/s')     # assertions per second
  print_right( 9,'cov(%)')    # coverage
  puts
  print_line
end

def print_module(stats)
  modules.each do |mod|
    h = stats[mod]
    print_left(15,mod)
    print_right( 5,h[:test_count])
    print_right( 7,h[:assertion_count])
    print_right( 3,h[:failure_count])
    print_right( 3,h[:error_count])
    print_right( 3,h[:skip_count])
    print_right( 9,h[:took])
    print_right( 9,h[:tests_per_sec])
    print_right( 9,h[:assertions_per_sec])
    print_right( 9,h[:coverage])
    puts
  end
end

def print_totals(stats)
  puts ' -' * 36
  print_left(15,'total')
  print_right( 5,    c=stats.map{|_,h| h[:test_count].to_i}.reduce(:+))
  print_right( 7,    a=stats.map{|_,h| h[:assertion_count].to_i}.reduce(:+))
  print_right( 3,      stats.map{|_,h| h[:failure_count]}.reduce(:+))
  print_right( 3,      stats.map{|_,h| h[:error_count]}.reduce(:+))
  print_right( 3,      stats.map{|_,h| h[:skip_count]}.reduce(:+))
  print_right( 9, t=f2(stats.map{|_,h| h[:took].to_f}.reduce(:+)))
  print_right( 9, f2(c / t.to_f))
  print_right( 9, f2(a / t.to_f))
  puts
  print_line
end

def print_line
  puts '-' * 72
end

#- - - - - - - - - - - - - - - - - - - - -

stats = gather_stats
print_heading
print_module(stats)
print_totals(stats)
