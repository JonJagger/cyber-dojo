#!/usr/bin/env ruby

# A ruby script to display stats on light colours per language.
#
# Running this on cyber-dojo.org 9th July 2015
# gave the following
#


require_relative 'lib_domain'

$stats = { }

def collect_light_stats(kata)
  language = kata.language.name
  $stats[language] ||= { :red => 0, :amber => 0, :green => 0 }
  kata.avatars.active.each do |avatar|
    lights = avatar.lights
    # discount avatars with 3 or less lights
    # as I often demo by showing red/amber/green
    if lights.length >= 4
      avatar.lights.each do |light|
        colour = light.colour
        if [:red,:amber,:green].include?(colour)
          $stats[language][colour] += 1
        end
      end
    end
  end
end

def print_percent(name, n, total)
    printf(name)
    if total != 0
      printf("%3.2f", (n.to_f / total) * 100)
    else
      printf("%3.2f", 0.0)
    end
end

def show_light_stats
  $stats.each do |language,counts|
    red   = counts[:red]
    amber = counts[:amber]
    green = counts[:green]
    puts "#{language}"
    puts "  totals:  red=#{red} amber=#{amber} green=#{green}"
    total = red + amber + green
    printf("  percent: ")
    print_percent("red=", red, total)
    print_percent(" amber=", amber, total)
    print_percent(" green=", green, total)
    puts
  end
end

puts
$dot_count = 0
$exceptions = [ ]
`rm -rf exceptions.log`

#$stop_at = 500
dojo = create_dojo
dojo.katas.each do |kata|
  begin
    $dot_count += 1
    collect_light_stats(kata)
    print "\r " + dots($dot_count)
  rescue Exception => error
    $exceptions << error.message
  end
  #break if $dot_count >= $stop_at
end
puts

show_light_stats
mention($exceptions)
