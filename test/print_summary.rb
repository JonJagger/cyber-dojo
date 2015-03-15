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

def indent
  16
end

def columns
  {
    :test_count         => [  5, 't',      'number of tests' ],
    :assertion_count    => [  7, 'a',      'number of assertions' ],
    :failure_count      => [  3, 'f',      'number of failures' ],
    :error_count        => [  3, 'e',      'number of errors' ],
    :skip_count         => [  3, 's',      'number of skips' ],
    :time               => [  6, 'time',   'time in seconds' ],
    :tests_per_sec      => [  9, 't/s',    'tests per second' ],
    :assertions_per_sec => [ 10, 'a/s',    'assertions per second' ],
    :coverage           => [  9, 'cov',    'coverage %' ],
  }
end

def column_names
  [ :test_count, :assertion_count, :failure_count, :error_count, :skip_count,
    :time, :tests_per_sec, :assertions_per_sec, :coverage ]
end

def line_width
  columns.map{|_,values| values[0]}.reduce(:+) + indent
end

def print_line
  puts '-' * line_width
end

#- - - - - - - - - - - - - - - - - - - - -

def gather_stats
  stats = { }
  number = '([\.|\d]+)'
  modules.each do |module_name|
        
    log = `cat #{module_name}/log.tmp`
    h = stats[module_name] = { }

    finished_pattern = "Finished in #{number}s, #{number} runs/s, #{number} assertions/s"
    m = log.match(Regexp.new(finished_pattern))
    h[:time]               = f2(m[1])
    h[:tests_per_sec]      = f2(m[2])
    h[:assertions_per_sec] = f2(m[3])

    summary_pattern = %w( runs assertions failures errors skips).map{ |s| "#{number} #{s}" }.join(', ')
    m = log.match(Regexp.new(summary_pattern))
    h[:test_count]      = m[1].to_i
    h[:assertion_count] = m[2].to_i
    h[:failure_count]   = m[3].to_i
    h[:error_count]     = m[4].to_i
    h[:skip_count]      = m[5].to_i

    coverage_pattern = "Coverage = #{number}%"    
    m = log.match(Regexp.new(coverage_pattern))
    h[:coverage] = f2(m[1])
  end
  stats
end

def print_heading
  print_left(indent, '')
  column_names.each { |name| print_right(columns[name][0], columns[name][1]) }
  puts
  print_line
end

def print_stats(stats)
  modules.each do |module_name|
    h = stats[module_name]
    print_left(indent, module_name)
    column_names.each { |name| print_right(columns[name][0], stats[module_name][name]) }
    puts
  end
end

def print_totals(stats)
  puts '- ' * ((line_width+1)/2)
  pr = lambda { |key,value| print_right(columns[key][0], value) }
  stat = lambda { |key| stats.map{|_,h| h[key].to_i}.reduce(:+) }
  print_left(indent, 'total')
  pr.call(:test_count,         c=stat.call(:test_count))
  pr.call(:assertion_count,    a=stat.call(:assertion_count))
  pr.call(:failure_count,        stat.call(:failure_count))
  pr.call(:error_count,          stat.call(:error_count))
  pr.call(:skip_count,           stat.call(:skip_count))
  pr.call(:time,               t=f2(stats.map{|_,h| h[:time].to_f}.reduce(:+)))
  pr.call(:tests_per_sec,        f2(c / t.to_f))
  pr.call(:assertions_per_sec,   f2(a / t.to_f))
  puts
  print_line
end

def print_key
  column_names.each do |name|
    puts columns[name][1] + ' == ' + columns[name][2]
  end
end

#- - - - - - - - - - - - - - - - - - - - -

stats = gather_stats
puts
print_heading
print_stats(stats)
print_totals(stats)
puts
print_key
puts
