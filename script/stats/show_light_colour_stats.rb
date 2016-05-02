#!/usr/bin/env ruby

# A ruby script to display stats on light colours per language.

require_relative '../lib_domain'

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
  $stats.sort.each do |language,counts|
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
    puts
  end
end

# - - - - - - - - - - - - - - - - - - - - - - - - -

puts
$dot_count = 0
$exceptions = [ ]
`rm -rf exceptions.log`

#$stop_at = 500
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


# - - - - - - - - - - - - - - - - - - - - - - - - -
#
# Running this on cyber-dojo.org 9th July 2015
# gave the following
#

=begin
23637

C-Unity
  totals:  red=868 amber=1831 green=1671
  percent: red=19.86 amber=41.90 green=38.24
C-assert
  totals:  red=3283 amber=9267 green=5999
  percent: red=17.70 amber=49.96 green=32.34

C++-assert
  totals:  red=4164 amber=8876 green=5809
  percent: red=22.09 amber=47.09 green=30.82
C++-GoogleTest
  totals:  red=5391 amber=11160 green=6297
  percent: red=23.60 amber=48.84 green=27.56
C++-Catch
  totals:  red=128 amber=519 green=125
  percent: red=16.58 amber=67.23 green=16.19
C++-CppUTest
  totals:  red=1120 amber=2398 green=1290
  percent: red=23.29 amber=49.88 green=26.83

C#-NUnit
  totals:  red=11306 amber=16609 green=12894
  percent: red=27.70 amber=40.70 green=31.60
C#-SpecFlow
  totals:  red=227 amber=264 green=188
  percent: red=33.43 amber=38.88 green=27.69

Java-1.8_Mockito
  totals:  red=1136 amber=1198 green=1099
  percent: red=33.09 amber=34.90 green=32.01
Java-1.8_JUnit
  totals:  red=15968 amber=22170 green=19789
  percent: red=27.57 amber=38.27 green=34.16
Java-1.8_Approval
  totals:  red=665 amber=587 green=319
  percent: red=42.33 amber=37.36 green=20.31
Java-1.8_Cucumber
  totals:  red=964 amber=942 green=528
  percent: red=39.61 amber=38.70 green=21.69
Java-1.8_JMock
  totals:  red=103 amber=129 green=80
  percent: red=33.01 amber=41.35 green=25.64
Java-1.8_Powermockito
  totals:  red=23 amber=11 green=21
  percent: red=41.82 amber=20.00 green=38.18

Javascript-mocha_chai_sinon
  totals:  red=106 amber=20 green=164
  percent: red=36.55 amber=6.90 green=56.55
Javascript-jasmine
  totals:  red=2470 amber=461 green=1624
  percent: red=54.23 amber=10.12 green=35.65

Python-pytest
  totals:  red=1404 amber=575 green=890
  percent: red=48.94 amber=20.04 green=31.02
Python-unittest
  totals:  red=5366 amber=6099 green=5711
  percent: red=31.24 amber=35.51 green=33.25

Ruby-TestUnit
  totals:  red=2450 amber=2373 green=2485
  percent: red=33.52 amber=32.47 green=34.00
Ruby-Rspec
  totals:  red=2106 amber=1079 green=1414
  percent: red=45.79 amber=23.46 green=30.75
Ruby-Cucumber
  totals:  red=104 amber=269 green=68
  percent: red=23.58 amber=61.00 green=15.42
Ruby-Approval
  totals:  red=30 amber=8 green=18
  percent: red=53.57 amber=14.29 green=32.14


Perl-TestSimple
  totals:  red=513 amber=81 green=236
  percent: red=61.81 amber=9.76 green=28.43

Erlang-eunit
  totals:  red=585 amber=442 green=429
  percent: red=40.18 amber=30.36 green=29.46

F#-NUnit
  totals:  red=28 amber=90 green=25
  percent: red=19.58 amber=62.94 green=17.48

CoffeeScript-jasmine
  totals:  red=390 amber=105 green=181
  percent: red=57.69 amber=15.53 green=26.78

Javascript-assert
  totals:  red=3759 amber=2712 green=3174
  percent: red=38.97 amber=28.12 green=32.91

PHP-PHPUnit
  totals:  red=3997 amber=2141 green=3417
  percent: red=41.83 amber=22.41 green=35.76

D-unittest
  totals:  red=0 amber=0 green=0
  percent: red=0.00 amber=0.00 green=0.00

R-RUnit
  totals:  red=1 amber=19 green=1
  percent: red=4.76 amber=90.48 green=4.76

Clojure-.test
  totals:  red=582 amber=351 green=386
  percent: red=44.12 amber=26.61 green=29.26

Groovy-JUnit
  totals:  red=173 amber=126 green=154
  percent: red=38.19 amber=27.81 green=34.00

Scala-scalatest
  totals:  red=7 amber=88 green=0
  percent: red=7.37 amber=92.63 green=0.00
C++-Igloo
  totals:  red=2 amber=7 green=1
  percent: red=20.00 amber=70.00 green=10.00
Haskell-hunit
  totals:  red=353 amber=936 green=567
  percent: red=19.02 amber=50.43 green=30.55
Go-testing
  totals:  red=452 amber=769 green=369
  percent: red=28.43 amber=48.36 green=23.21
Fortran-FUnit
  totals:  red=64 amber=137 green=61
  percent: red=24.43 amber=52.29 green=23.28
Groovy-Spock
  totals:  red=159 amber=108 green=134
  percent: red=39.65 amber=26.93 green=33.42

BCPL-all_tests_passed
  totals:  red=0 amber=0 green=0
  percent: red=0.00 amber=0.00 green=0.00
R-stopifnot
  totals:  red=0 amber=0 green=0
  percent: red=0.00 amber=0.00 green=0.00
C++-Boost.Test
  totals:  red=0 amber=0 green=0
  percent: red=0.00 amber=0.00 green=0.00
Asm-assert
  totals:  red=0 amber=0 green=0
  percent: red=0.00 amber=0.00 green=0.00
BCPL
  totals:  red=10 amber=11 green=3
  percent: red=41.67 amber=45.83 green=12.50
=end
