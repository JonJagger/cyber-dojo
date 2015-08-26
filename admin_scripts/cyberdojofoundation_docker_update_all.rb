#!/usr/bin/env ruby

def conversion
  [
# Asm
    [ "cyberdojo/nasm-2.10.0",                  "cyberdojofoundation/nasm-2.10.0" ],
    [ "cyberdojo/nasm-2.10.0_assert",           "cyberdojofoundation/nasm-2.10.0_assert" ],
# Bash
    [ "cyberdojo/bash",                         "cyberdojofoundation/bash" ],
    [ "cyberdojo/bash_shunit2",                 "cyberdojofoundation/bash_shunit2" ],
# BCPL
    [ "cyberdojo/bcpl",                         "cyberdojofoundation/bcpl" ],
    [ "cyberdojo/bcpl-all_tests_passed",        "cyberdojofoundation/bcpl-all_tests_passed" ],
# build-essential
    [ "cyberdojo/build-essential",              "cyberdojofoundation/build-essential" ],
# C#
    [ "cyberdojo/csharp-2.10.8.1",              "cyberdojofoundation/csharp-2.10.8.1" ],
    [ "cyberdojo/csharp-2.10.8.1_nunit",        "cyberdojofoundation/csharp-2.10.8.1_nunit" ],
    [ "cyberdojo/csharp-2.10.8.1_specflow",     "cyberdojofoundation/csharp-2.10.8.1_specflow" ],
# C (clang)
    [ "cyberdojo/clang-3.6.1",                  "cyberdojofoundation/clang-3.6.1" ],
    [ "cyberdojo/clang-3.6.1_assert",           "cyberdojofoundation/clang-3.6.1_assert" ],
# C++ (clang++)
    [ "cyberdojo/clang-3.6.0",                  "cyberdojofoundation/clang-3.6.0" ],
    [ "cyberdojo/clang-3.6.0_assert",           "cyberdojofoundation/clang-3.6.0_assert" ],
    [ "cyberdojo/clang-3.6.0_googletest",       "cyberdojofoundation/clang-3.6.0_googletest" ],
# C (gcc)
    [ "cyberdojo/gcc-4.8.1",                    "cyberdojofoundation/gcc-4.8.1" ],
    [ "cyberdojo/gcc-4.8.1_assert",             "cyberdojofoundation/gcc-4.8.1_assert" ],
    [ "cyberdojo/gcc-4.8.1_cpputest",           "cyberdojofoundation/gcc-4.8.1_cpputest" ],
    [ "cyberdojo/gcc-4.8.1_unity",              "cyberdojofoundation/gcc-4.8.1_unity" ],
# Clojure
    [ "cyberdojo/clojure-1.4.0",                "cyberdojofoundation/clojure-1.4.0" ],
# CoffeeScript
    [ "cyberdojo/coffeescript-1.14.3",          "cyberdojofoundation/coffeescript-1.14.3" ],
    [ "cyberdojo/coffeescript-1.14.3_jasmine",  "cyberdojofoundation/coffeescript-1.14.3_jasmine" ],
# D
    [ "cyberdojo/d-4.8.1",                      "cyberdojofoundation/d-4.8.1" ],
    [ "cyberdojo/d-4.8.1_unittest",             "cyberdojofoundation/d-4.8.1_unittest" ],
# Erlang
    [ "cyberdojo/erlang-5.10.2",                "cyberdojofoundation/erlang-5.10.2" ],
    [ "cyberdojo/erlang-5.10.2_eunit",          "cyberdojofoundation/erlang-5.10.2_eunit" ],
# F#
    [ "cyberdojo/fsharp-3.0",                   "cyberdojofoundation/fsharp-3.0" ],
    [ "cyberdojo/fsharp-3.0_nunit",             "cyberdojofoundation/fsharp-3.0_nunit" ],
# Fortran
    [ "cyberdojo/fortran-4.8",                  "cyberdojofoundation/fortran-4.8" ],
    [ "cyberdojo/fortran-4.8_funit",            "cyberdojofoundation/fortran-4.8_funit" ],
# g++4.8.1
    [ "cyberdojo/gpp-4.8.1",                    "cyberdojofoundation/gpp-4.8.1" ],
    [ "cyberdojo/gpp-4.8.1_assert",             "cyberdojofoundation/gpp-4.8.1_assert" ],
    [ "cyberdojo/gpp-4.8.1_boosttest",          "cyberdojofoundation/gpp-4.8.1_boosttest" ],
    [ "cyberdojo/gpp-4.8.1_catch",              "cyberdojofoundation/gpp-4.8.1_catch" ],
    [ "cyberdojo/gpp-4.8.1_cpputest",           "cyberdojofoundation/gpp-4.8.1_cpputest" ],
    [ "cyberdojo/gpp-4.8.1_googletest",         "cyberdojofoundation/gpp-4.8.1_googletest" ],
    [ "cyberdojo/gpp-4.8.1_igloo",              "cyberdojofoundation/gpp-4.8.1_igloo" ],
# g++4.9
    [ "cyberdojo/gpp-4.9",                      "cyberdojofoundation/gpp-4.9" ],
    [ "cyberdojo/gpp-4.9_googlemock",           "cyberdojofoundation/gpp-4.9_googlemock" ],
# Go
    [ "cyberdojo/go-1.1.2",                     "cyberdojofoundation/go-1.1.2" ],
    [ "cyberdojo/go-1.1.2_testing",             "cyberdojofoundation/go-1.1.2_testing" ],
# Groovy
    [ "cyberdojo/groovy-2.2.0",                 "cyberdojofoundation/groovy-2.4.4" ],
    [ "cyberdojo/groovy-2.2.0_spock",           "cyberdojofoundation/groovy-2.4.4_spock" ],
    [ "cyberdojo/groovy-2.2.0_junit",           "cyberdojofoundation/groovy-2.4.4_junit" ],
# Haskell
    [ "cyberdojo/haskell-7.6.3",                "cyberdojofoundation/haskell-7.6.3" ],
    [ "cyberdojo/haskell-7.6.3_hunit",          "cyberdojofoundation/haskell-7.6.3_hunit" ],
# Java
    [ "cyberdojo/java-1.8",                     "cyberdojofoundation/java-1.8" ],
    [ "cyberdojo/java-1.8_approval",            "cyberdojofoundation/java-1.8_approval" ],
    [ "cyberdojo/java-1.8_cucumber",            "cyberdojofoundation/java-1.8_cucumber" ],
    [ "cyberdojo/java-1.8_jmock",               "cyberdojofoundation/java-1.8_jmock" ],
    [ "cyberdojo/java-1.8_junit",               "cyberdojofoundation/java-1.8_junit" ],
    [ "cyberdojo/java-1.8_mockito",             "cyberdojofoundation/java-1.8_mockito" ],
    [ "cyberdojo/java-1.8_powermockito",        "cyberdojofoundation/java-1.8_powermockito" ],
# Javascript
    [ "cyberdojo/javascript-0.10.15",           "cyberdojofoundation/javascript-0.10.15" ],
    [ "cyberdojo/javascript-0.10.15_assert",    "cyberdojofoundation/javascript-0.10.15_assert" ],
    [ "cyberdojo/javascript-0.10.15_jasmine",   "cyberdojofoundation/javascript-0.10.15_jasmine" ],
    [ "cyberdojo/javascript-mocha",             "cyberdojofoundation/javascript-mocha" ],
# Perl
    [ "cyberdojo/perl-5.14.2",                  "cyberdojofoundation/perl-5.14.2" ],
    [ "cyberdojo/perl-5.14.2_test_simple",      "cyberdojofoundation/perl-5.14.2_test_simple" ],
# PHP
    [ "cyberdojo/php-5.5.3",                    "cyberdojofoundation/php-5.5.3" ],
    [ "cyberdojo/php-5.5.3_phpunit",            "cyberdojofoundation/php-5.5.3_phpunit" ],
# Python
    [ "cyberdojo/python-3.3.5",                 "cyberdojofoundation/python-3.3.5" ],
    [ "cyberdojo/python-3.3.5_pytest",          "cyberdojofoundation/python-3.3.5_pytest" ],
    [ "cyberdojo/python-3.3.5_unittest",        "cyberdojofoundation/python-3.3.5_unittest" ],
# R
    [ "cyberdojo/r-3.0.1",                      "cyberdojofoundation/r-3.0.1" ],
    [ "cyberdojo/r-3.0.1_runit",                "cyberdojofoundation/r-3.0.1_runit" ],
# Ruby1.9.3
    [ "cyberdojo/ruby-1.9.3",                   "cyberdojofoundation/ruby-1.9.3" ],
    [ "cyberdojo/ruby-1.9.3_approval",          "cyberdojofoundation/ruby-1.9.3_approval" ],
    [ "cyberdojo/ruby-1.9.3_cucumber",          "cyberdojofoundation/ruby-1.9.3_cucumber" ],
    [ "cyberdojo/ruby-1.9.3_rspec",             "cyberdojofoundation/ruby-1.9.3_rspec" ],
    [ "cyberdojo/ruby-1.9.3_test_unit",         "cyberdojofoundation/ruby-1.9.3_test_unit" ],
# Ruby2.1.3
    [ "cyberdojo/ruby-2.1.3",                   "cyberdojofoundation/ruby-2.1.3" ],
    [ "cyberdojo/ruby-2.1.3_mini_test",         "cyberdojofoundation/ruby-2.1.3_mini_test" ],
# Rust
    [ "cyberdojo/rust-1.0.0",                   "cyberdojofoundation/rust-1.0.0" ],
    [ "cyberdojo/rust-1.0.0_test",              "cyberdojofoundation/rust-1.0.0_test" ],
# Scala
    [ "cyberdojo/scala-2.9.2",                  "cyberdojofoundation/scala-2.11.7" ],
    [ "cyberdojo/scala-2.9.2_scalatest",        "cyberdojofoundation/scala-2.11.7_scalatest" ],
# VisualBasic
    [ "cyberdojo/visual_basic-0.5943",          "cyberdojofoundation/visual_basic-0.5943" ],
    [ "cyberdojo/visual_basic-0.5943_nunit",    "cyberdojofoundation/visual_basic-0.5943_nunit" ],
  ]
end

def installed_images
  output = `docker images 2>&1`
  lines = output.split("\n").select{|line| line.start_with?('cyberdojo')}
  lines.collect{|line| line.split[0]}.sort
end

def update_images
  images = installed_images
  images.each do |image|
    update_to = image
    print image
    index = conversion.find_index{|p| p[0]===image}
    if index != nil
      update_to = conversion[index][1]
      print " -> #{update_to}"
    end
    print "\n"
  end
end

def remove_old_images
  images = installed_images
  images.each do |image|
    index = conversion.find_index{|p| p[0]===image}
    if index != nil
      print "Removing " + image + "\n"
    end
  end
end

def console_break
  puts "--------------------------------------------------------------------------------"
end

if ($0 == __FILE__)
  console_break
  puts "Pulling latest images"
  console_break
  update_images
end

if (ARGV[0] === "clean")
  console_break
  puts "Removing old images"
  console_break
  remove_old_images
end
