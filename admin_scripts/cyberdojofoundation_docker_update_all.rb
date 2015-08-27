#!/usr/bin/env ruby

def foundation(original_name, updated_name = original_name)
  [ "cyberdojo/" + original_name , "cyberdojofoundation/" + updated_name  ]
end

def conversion
  [
# Asm
    foundation("nasm-2.10.0"),
    foundation("nasm-2.10.0_assert"),
# Bash
    foundation("bash"),
    foundation("bash_shunit2"),
# BCPL
    foundation("bcpl"),
    foundation("bcpl-all_tests_passed"),
# build-essential
    foundation("build-essential"),
# C#
    foundation("csharp-2.10.8.1"),
    foundation("csharp-2.10.8.1_nunit"),
    foundation("csharp-2.10.8.1_specflow"),
# C (clang)
    foundation("clang-3.6.1"),
    foundation("clang-3.6.1_assert"),
# C++ (clang++)
    foundation("clang-3.6.0"),
    foundation("clang-3.6.0_assert"),
    foundation("clang-3.6.0_googletest"),
# C (gcc)
    foundation("gcc-4.8.1"),
    foundation("gcc-4.8.1_assert"),
    foundation("gcc-4.8.1_cpputest"),
    foundation("gcc-4.8.1_unity"),
# Clojure
    foundation("clojure-1.4.0"),
# CoffeeScript
    foundation("coffeescript-1.14.3"),
    foundation("coffeescript-1.14.3_jasmine"),
# D
    foundation("d-4.8.1"),
    foundation("d-4.8.1_unittest"),
# Erlang
    foundation("erlang-5.10.2"),
    foundation("erlang-5.10.2_eunit"),
# F#
    foundation("fsharp-3.0"),
    foundation("fsharp-3.0_nunit"),
# Fortran
    foundation("fortran-4.8"),
    foundation("fortran-4.8_funit"),
# g++4.8.1
    foundation("gpp-4.8.1",                  "gpp-4.8.4"),
    foundation("gpp-4.8.1_assert",           "gpp-4.8.4_assert"),
    foundation("gpp-4.8.1_boosttest",        "gpp-4.8.4_boosttest"),
    foundation("gpp-4.8.1_catch",            "gpp-4.8.4_catch"),
    foundation("gpp-4.8.1_cpputest",         "gpp-4.8.4_cpputest"),
    foundation("gpp-4.8.1_googletest",       "gpp-4.8.4_googletest"),
    foundation("gpp-4.8.1_igloo",            "gpp-4.8.4_igloo"),
# g++4.9
    foundation("gpp-4.9"),
    foundation("gpp-4.9_googlemock"),
# Go
    foundation("go-1.1.2"),
    foundation("go-1.1.2_testing"),
# Groovy
    foundation("groovy-2.2.0",               "groovy-2.4.4"),
    foundation("groovy-2.2.0_spock",         "groovy-2.4.4_spock"),
    foundation("groovy-2.2.0_junit",         "groovy-2.4.4_junit"),
# Haskell
    foundation("haskell-7.6.3"),
    foundation("haskell-7.6.3_hunit"),
# Java
    foundation("java-1.8"),
    foundation("java-1.8_approval"),
    foundation("java-1.8_cucumber"),
    foundation("java-1.8_jmock"),
    foundation("java-1.8_junit"),
    foundation("java-1.8_mockito"),
    foundation("java-1.8_powermockito"),
# Javascript
    foundation("javascript-0.10.15"),
    foundation("javascript-0.10.15_assert"),
    foundation("javascript-0.10.15_jasmine"),
    foundation("javascript-mocha"),
# Perl
    foundation("perl-5.14.2"),
    foundation("perl-5.14.2_test_simple"),
# PHP
    foundation("php-5.5.3"),
    foundation("php-5.5.3_phpunit"),
# Python
    foundation("python-3.3.5"),
    foundation("python-3.3.5_pytest"),
    foundation("python-3.3.5_unittest"),
# R
    foundation("r-3.0.1"),
    foundation("r-3.0.1_runit"),
# Ruby1.9.3
    foundation("ruby-1.9.3"),
    foundation("ruby-1.9.3_approval"),
    foundation("ruby-1.9.3_cucumber"),
    foundation("ruby-1.9.3_rspec"),
    foundation("ruby-1.9.3_test_unit"),
# Ruby2.1.3
    foundation("ruby-2.1.3"),
    foundation("ruby-2.1.3_mini_test"),
# Rust
    foundation("rust-1.0.0"),
    foundation("rust-1.0.0_test"),
# Scala
    foundation("scala-2.9.2",                 "scala-2.11.7"),
    foundation("scala-2.9.2_scalatest",       "scala-2.11.7_scalatest"),
# VisualBasic
    foundation("visual_basic-0.5943"),
    foundation("visual_basic-0.5943_nunit")
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
