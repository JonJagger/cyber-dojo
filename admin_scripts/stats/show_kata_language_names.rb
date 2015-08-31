#!/usr/bin/env ruby

require_relative '../lib_domain'

puts
names = { }
dot_count = 0
dojo.katas.each do |kata|
  manifest = JSON.parse(kata.dir.read('manifest.json'))
  name = manifest['language']
  names[name] ||=  []
  names[name] << kata.id
  dot_count += 1
  print "\rworking" + dots(dot_count)
end
puts
puts

names.keys.sort.each do |name| 
  p "#{name} #{names[name].size} #{names[name][0]}"
end

# TODO?: Write a script to fix up all the katas on the main server
#       so the language entry in their manifests is fixed and is
#       split into two entries, one for the language name and one for 
#       the test name.
#


=begin
"Asm-assert 25 010E66019D"

"BCPL 3 DF9A083C0F"

"BCPL-all_tests_passed 18 C411C2351E"

"C 479 54529AA3BE"

"C# 1473 54F993C99A"

"C#-NUnit 3088 54009537D3"

"C#-SpecFlow 229 543E10EB15"

"C++ 535 54E041DECA"

"C++-Boost.Test 55 54C6A3B75B"

"C++-Catch 352 54652F82AD"

"C++-CppUTest 662 54A93BB04C"

"C++-GoogleMock 19 280B752660"

"C++-GoogleTest 1452 54C157173A"

"C++-Igloo 46 280DB28223"

"C++-assert 1015 545111471C"

"C-Unity 450 5498403AF6"

"C-assert 836 54B99F4CE2"

"Clojure 67 5A53D42987"

"Clojure-.test 177 546B4184B4"

"CoffeeScript 47 014F4190E0"

"CoffeeScript-jasmine 83 54219ECA71"

"D-unittest 45 541349CE61"

"Erlang 45 282F687601"

"Erlang-eunit 121 543F979F1C"

"F#-NUnit 101 5447BFDCB0"

"Fortran-FUnit 64 016105DBCD"

"Go 47 AA393DDF4B"

"Go-testing 155 2849773A9C"

"Groovy-JUnit 117 5A776302BC"

"Groovy-Spock 109 AADE304AC9"

"Haskell 81 23939E0066"

"Haskell-hunit 146 28894CFFC1"

"Java 17 23A7CF3454"

"Java-1.8_Approval 389 54D58851FE"

"Java-1.8_Cucumber 228 54303D90C6"

"Java-1.8_JMock 43 C484782160"

"Java-1.8_JUnit 3648 5437D7B510"

"Java-1.8_Mockito 313 540E06E467"

"Java-1.8_Powermockito 56 339F6FF85A"

"Java-Approval 220 54624C174C"

"Java-Cucumber 163 543D714DF5"

"Java-JUnit 1708 54FB5612C3"

"Java-JUnit-Mockito 160 54359DB8B5"

"Java-Mockito 37 020B8A969E"

"Java-PowerMockito 6 D360343B60"

"Javascript 474 54210DA681"

"Javascript-assert 517 549D533F36"

"Javascript-jasmine 534 5A749EFF33"

"Javascript-mocha_chai_sinon 128 5A405D8EE2"

"PHP 396 54C77C53AA"

"PHP-PHPUnit 827 541E1B649B"

"Perl 57 549C58C8BA"

"Perl-TestSimple 112 287BE6DEDB"

"Python 621 54F07B407C"

"Python-pytest 815 5496730F04"

"Python-unittest 1242 548F3E67A7"

"R-RUnit 37 54811DAFB1"

"R-stopifnot 2 F0A5407B87"

"Ruby 339 54EE119F79"

"Ruby-Approval 149 283E57E66D"

"Ruby-Cucumber 154 28A62BD7AA"

"Ruby-Rspec 508 545144CA06"

"Ruby-TestUnit 412 546A3CCA40"

"Scala-scalatest 190 5A3EE246D6"

=end
