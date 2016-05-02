#!/usr/bin/env ruby

# A ruby script to display stats on light->light transitions.

require_relative '../lib_domain'

$stats =
{
  [:green,:green] => [ ],
  [:green,:amber] => [ ],
  [:green,:red  ] => [ ],

  [:amber,:green] => [ ],
  [:amber,:amber] => [ ],
  [:amber,:red  ] => [ ],

  [:red,:green] => [ ],
  [:red,:amber] => [ ],
  [:red,:red  ] => [ ],
}

def deleted_file(lines)
  lines.all? { |line| line[:type] === :deleted }
end

def new_file(lines)
  lines.all? { |line| line[:type] === :added }
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
          if !non_code_filenames.include?(filename) &&
             !deleted_file(lines) &&
             !new_file(lines)
            line_count += lines.count { |line| line[:type] === :added }
            line_count += lines.count { |line| line[:type] === :deleted }
          end
        end

        key = [was.colour,now.colour]
        $stats[key] << line_count if line_count != 0

        #puts "#{kata.id}:#{avatar.name}: " +
        #     "(#{was.number}<->#{now.number}) " +
        #     "(#{now.colour},#{line_count}) "

      end
    end
  end
end

def mean_count(from,to)
  key = [from,to]
  values = $stats[key]
  count = values.length
  total = values.inject(:+)
  mean = total.to_f / count
  [mean, count]
end

def show_diff_stats(n)
  from_to_stats = [ ]
  froms = [:red,:amber,:green]
  tos = [:red,:amber,:green]
  froms.each do |from|
    tos.each do |to|
      mean,count = mean_count(from,to)
      from_to_stats << [mean,[from,to],count]
    end
  end
  puts
  from_to_stats.sort.each do |mean,key,count|
    printf("%7.2f %6s->%6s \t %6d\n", mean, key[0], key[1], count)
  end
  puts
  light_count = from_to_stats.collect{|a| a[2]}.inject(:+)
  lights_per_kata = light_count.to_f / n
  puts "#{light_count} lights"
  printf("%7.2f lights/kata\n", lights_per_kata)
end

# - - - - - - - - - - - - - - - - - - - - - - - - - -

puts
$dot_count = 0
$exceptions = [ ]
`rm -rf exceptions.log`


$stop_at = 500
dojo.katas.each do |kata|
  begin
    $dot_count += 1
    collect_diff_stats(kata)
    print "\r " + dots($dot_count)
  rescue Exception => error
    $exceptions << error.message
  end
  break if $dot_count >= $stop_at
end
puts

show_diff_stats($stop_at)
mention($exceptions)

# - - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Running this on cyber-dojo.org 12th July 2014
# gave the following
#
# 500 katas
# 5385 lights
# 10.77 lights/kata
#
#   3.94  amber-> green 	    447  (1)
#   4.65  amber->   red 	    379  (1)
#   4.67  amber-> amber 	   1462  (2)
#   5.39    red-> green 	    607  (3)
#   6.01    red->   red 	    604  (3)
#   7.52  green->   red 	    420  (3)
#  13.65  green-> amber 	    436  (3)
#  17.67    red-> amber 	    432  (3)
#  22.18  green-> green 	    598  (4)
#
# Where the top line means...
# the average number of edited lines for an
# amber->green transition was 3.94 and there
# were 447 such transitions in the 500 katas analyzed.
#
# Possible interpretations
#
# (1) if you're at amber and you want to get off it
#     you're better off making a small change.
# (2) if you're at amber and you make a small change
#     it's still quite likely you'll stay at amber.
#     Notice the spike (1462 amber->amber)
# (3) if you're at red or green the larger the change
#     the more likely you are to get an amber.
# (4) ???? interesting. Gather examples...
#

