#!/usr/bin/env ruby

# A ruby script to display stats on light-light diffs.

require File.dirname(__FILE__) + '/lib_domain'

$stats =
{
  :green => [ ],
  :amber => [ ],
  :red   => [ ]
}

def deleted_file(lines)
  lines.all? { |line| line[:type] === :deleted }
end

def collect_diff_stats(kata)
  kata.avatars.active.each do |avatar|
    lights = avatar.lights
    # discount avatars with 3 or less lights
    # as I often demo by showing red/amber/green
    if lights.length >= 4
      avatar.lights.each_cons(2) do |was,now|

        line_count = 0;
        diff = avatar.tags[was.number].diff(now.number)
        diff.each do |filename,lines|
          non_code_filenames = [ 'output', 'cyber-dojo.sh', 'instructions' ]
          if !non_code_filenames.include?(filename) && !deleted_file(lines)
            line_count += lines.count { |line| line[:type] === :added }
            line_count += lines.count { |line| line[:type] === :deleted }
          end
        end

        $stats[now.colour] << line_count if line_count != 0

        #puts "#{kata.id}:#{avatar.name}: " +
        #     "(#{was.number}<->#{now.number}) " +
        #     "(#{now.colour},#{line_count}) "

      end
    end
  end
end

def show_mean(symbol)
  values = $stats[symbol]
  count = values.length
  total = values.inject(:+)
  mean = total.to_f / count
  printf("%4.2f  %s \t %6d\n", mean, symbol.to_s, count)
  count
end

def show_diff_stats
  puts
  light_count = 0
  light_count += show_mean(:red)
  light_count += show_mean(:amber)
  light_count += show_mean(:green)
  puts '(' + light_count.to_s + ' lights)'
  puts
end


puts
$dot_count = 0
$exceptions = [ ]
`rm -rf exceptions.log`


dojo = create_dojo
dojo.katas.each do |kata|
  begin
    $dot_count += 1
    collect_diff_stats(kata)
    print "\r " + dots($dot_count)
  rescue Exception => error
    $exceptions << error.message
  end
  break if $dot_count >= 1000
end
puts

show_diff_stats
mention($exceptions)
