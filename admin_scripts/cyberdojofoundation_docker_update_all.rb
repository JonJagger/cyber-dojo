#!/usr/bin/env ruby

def conversion
  [

    [ "cyberdojo/clang-3.6.0_googletest",       "cyberdojofoundation/clang-3.6.0_googletest" ],
    [ "cyberdojo/rust-1.0.0_test",              "cyberdojofoundation/rust-1.0.0_test" ],
    [ "cyberdojo/bash_shunit2",                 "cyberdojofoundation/bash_shunit2" ],
    [ "cyberdojo/fsharp-3.0_nunit",             "cyberdojofoundation/" ],
    [ "cyberdojo/gcc-4.8.1_cpputest",           "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.9_googlemock",           "cyberdojofoundation/" ],
    [ "cyberdojo/ruby-2.1.3_mini_test",         "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1_boosttest",          "cyberdojofoundation/" ],
    [ "cyberdojo/csharp-2.10.8.1_specflow",     "cyberdojofoundation/" ],
    [ "cyberdojo/csharp-2.10.8.1_nunit",        "cyberdojofoundation/" ],
    [ "cyberdojo/bcpl-all_tests_passed",        "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1_igloo",              "cyberdojofoundation/" ],
    [ "cyberdojo/javascript-mocha",             "cyberdojofoundation/" ],
    [ "cyberdojo/r-3.0.1_runit",                "cyberdojofoundation/" ],
    [ "cyberdojo/nasm-2.10.0_assert",           "cyberdojofoundation/" ],
    [ "cyberdojo/gcc-4.8.1_unity",              "cyberdojofoundation/" ],
    [ "cyberdojo/fortran-4.8_funit",            "cyberdojofoundation/" ],
    [ "cyberdojo/d-4.8.1_unittest",             "cyberdojofoundation/" ],
    [ "cyberdojo/ruby-1.9.3_approval",          "cyberdojofoundation/" ],
    [ "cyberdojo/ruby-1.9.3_cucumber",          "cyberdojofoundation/" ],
    [ "cyberdojo/ruby-1.9.3_rspec",             "cyberdojofoundation/" ],
    [ "cyberdojo/javascript-0.10.15_jasmine",   "cyberdojofoundation/" ],
    [ "cyberdojo/scala-2.9.2_scalatest",        "cyberdojofoundation/" ],
    [ "cyberdojo/coffeescript-1.14.3_jasmine",  "cyberdojofoundation/" ],
    [ "cyberdojo/javascript-0.10.15_assert",    "cyberdojofoundation/" ],
    [ "cyberdojo/php-5.5.3_phpunit",            "cyberdojofoundation/" ],
    [ "cyberdojo/groovy-2.2.0_spock",           "cyberdojofoundation/" ],
    [ "cyberdojo/groovy-2.2.0_junit",           "cyberdojofoundation/" ],
    [ "cyberdojo/java-1.8_approval",            "cyberdojofoundation/" ],
    [ "cyberdojo/java-1.8_powermockito",        "cyberdojofoundation/" ],
    [ "cyberdojo/java-1.8_mockito",             "cyberdojofoundation/" ],
    [ "cyberdojo/java-1.8_cucumber",            "cyberdojofoundation/" ],
    [ "cyberdojo/java-1.8_junit",               "cyberdojofoundation/" ],
    [ "cyberdojo/java-1.8_jmock",               "cyberdojofoundation/" ],
    [ "cyberdojo/go-1.1.2_testing",             "cyberdojofoundation/" ],
    [ "cyberdojo/python-3.3.5_pytest",          "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1_googletest",         "cyberdojofoundation/" ],
    [ "cyberdojo/python-3.3.5_unittest",        "cyberdojofoundation/" ],
    [ "cyberdojo/perl-5.14.2_test_simple",      "cyberdojofoundation/" ],
    [ "cyberdojo/haskell-7.6.3_hunit",          "cyberdojofoundation/" ],
    [ "cyberdojo/erlang-5.10.2_eunit",          "cyberdojofoundation/" ],
    [ "cyberdojo/ruby-1.9.3_test_unit",         "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1_cpputest",           "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1_assert",             "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1_catch",              "cyberdojofoundation/" ],
    [ "cyberdojo/gcc-4.8.1_assert",             "cyberdojofoundation/" ],
    [ "cyberdojo/gpp-4.8.1",                    "cyberdojofoundation/" ],
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
