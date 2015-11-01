#!/usr/bin/env ruby

def cdf
  'cyberdojofoundation'
end

def language(old_name, new_name = old_name)
  [ "cyberdojo/" + old_name , "#{cdf}/" + new_name  ]
end

def foundation(old_name, new_name = old_name)
  [ "cyberdojo/" + old_name , "#{cdf}/" + new_name  ]
end

def no_version(old_name, new_name)
  fail "no_version #{old_name} == #{new_name}" if old_name == new_name
  [ "#{cdf}/" + old_name , "#{cdf}/" + new_name  ]
end

def conversion
  [
# build-essential
    language("build-essential"),

# Asm
    language("nasm-2.10.0", "nasm-2.10.09"),
    foundation("nasm-2.10.0_assert",  "nasm_assert"),
    no_version("nasm-2.10.09_assert", "nasm_assert"),

# Bash
    language("bash"),
    foundation("bash_shunit2"),

# BCPL
    language("bcpl"),
    foundation("bcpl-all_tests_passed"),

# C#
    language("csharp-2.10.8.1"),
    foundation("csharp-2.10.8.1_nunit",    "csharp_nunit"),
    no_version("csharp-2.10.8.1_nunit",    "csharp_nunit"),
    foundation("csharp-2.10.8.1_specflow", "csharp_specflow"),
    no_version("csharp-2.10.8.1_specflow", "csharp_specflow"),

# C (clang)
    language("clang-3.6.1"),
    foundation("clang-3.6.1_assert", "clang_assert"),
    no_version("clang-3.6.1_assert", "clang_assert"),

# C (gcc)
    language("gcc-4.8.1", "gcc-4.8.4"),
    foundation("gcc-4.8.1_assert",   "gcc_assert"),
    no_version("gcc-4.8.4_assert",   "gcc_assert"),
    foundation("gcc-4.8.1_cpputest", "gcc_cpputest"),
    no_version("gcc-4.8.4_cpputest", "gcc_cpputest"),
    foundation("gcc-4.8.1_unity",    "gcc_unity"),
    no_version("gcc-4.8.4_unity",    "gcc_unity"),

# C++ (clang++)
    language("clang-3.6.0", "clangpp-3.6.0"),
    foundation("clang-3.6.0_assert",     "clangpp_assert"),
    no_version("clang-3.6.0_assert",     "clangpp_assert"),
    foundation("clang-3.6.0_googletest", "clangpp_googletest"),
    no_version("clang-3.6.0_googletest", "clangpp_googletest"),

# C++ (g++) 4.8.4
    language("gpp-4.8.1", "gpp-4.8.4"),
    foundation("gpp-4.8.1_assert",     "gpp_assert"),
    no_version("gpp-4.8.4_assert",     "gpp_assert"),
    foundation("gpp-4.8.1_boosttest",  "gpp_boosttest"),
    no_version("gpp-4.8.4_boosttest",  "gpp_boosttest"),
    foundation("gpp-4.8.1_catch",      "gpp_catch"),
    no_version("gpp-4.8.4_catch",      "gpp_catch"),
    foundation("gpp-4.8.1_cpputest",   "gpp_cpputest"),
    no_version("gpp-4.8.4_cpputest",   "gpp_cpputest"),
    foundation("gpp-4.8.1_googletest", "gpp_googletest"),
    no_version("gpp-4.8.4_googletest", "gpp_googletest"),
    foundation("gpp-4.8.1_igloo",      "gpp_igloo"),
    no_version("gpp-4.8.4_igloo",      "gpp_igloo"),

# C++ (g++) 4.9
    foundation("gpp-4.9_googlemock", "gpp_googlemock"),
    no_version("gpp-4.9_googlemock", "gpp_googlemock"),

# Clojure
    language("clojure-1.4.0"),
    foundation("clojure-1.4.0_test"),

# CoffeeScript
    language("coffeescript-1.14.3"),
    foundation("coffeescript-1.14.3_jasmine", "coffeescript_jasmine"),
    no_version("coffeescript-1.14.3_jasmine", "coffeescript_jasmine"),

# D
    language("d-4.8.1", "d-4.8.4"),
    foundation("d-4.8.1_unittest", "d_unittest"),
    no_version("d-4.8.4_unittest", "d_unittest"),

# Erlang
    language("erlang-5.10.2", "erlang-5.10.4"),
    foundation("erlang-5.10.2_eunit", "erlang_eunit"),
    no_version("erlang-5.10.4_eunit", "erlang_eunit"),

# F#
    language("fsharp-3.0"),
    foundation("fsharp-3.0_nunit", "fsharp_nunit"),
    no_version("fsharp-3.0_nunit", "fsharp_nunit"),

# Fortran
    language("fortran-4.8", "fortran-4.8.4"),
    foundation("fortran-4.8_funit",   "fortra_funit"),
    no_version("fortran-4.8.4_funit", "fortran_funit"),

# Go
    language("go-1.1.2", "go-1.2.1"),
    foundation("go-1.1.2_testing", "go_testing"),
    no_version("go-1.2.1_testing", "go_testing"),

# Groovy
    language("groovy-2.2.0", "groovy-2.4.4"),
    foundation("groovy-2.2.0_junit", "groovy_junit"),
    no_version("groovy-2.4.4_junit", "groovy_junit"),
    foundation("groovy-2.2.0_spock", "groovy_spock"),
    no_version("groovy-2.4.4_spock", "groovy_spock"),

# Haskell
    language("haskell-7.6.3"),
    foundation("haskell-7.6.3_hunit", "haskell_hunit"),
    no_version("haskell-7.6.3_hunit", "haskell_hunit"),

# Java
    language("java-1.8"),
    foundation("java-1.8_approval",     "java_approval"),
    no_version("java-1.8_approval",     "java_approval"),
    foundation("java-1.8_cucumber",     "java_cucumber"),
    no_version("java-1.8_cucumber",     "java_cucumber"),
    foundation("java-1.8_jmock",        "java_jmock"),
    no_version("java-1.8_jmock",        "java_jmock"),
    foundation("java-1.8_junit",        "java_junit"),
    no_version("java-1.8_junit",        "java_junit"),
    foundation("java-1.8_mockito",      "java_mockito"),
    no_version("java-1.8_mockito",      "java_mockito"),
    foundation("java-1.8_powermockito", "java_powermockito"),
    no_version("java-1.8_powermockito", "java_powermockito"),

# Javascript
    language("javascript-0.10.15", "javascript-node-2.1"),
    language("javascript-0.10.25", "javascript-node-2.1"),
    foundation("javascript-0.10.15_assert",           "javascript-node_assert"),
    foundation("javascript-0.10.25_assert",           "javascript-node_assert"),
    foundation("javascript-0.10.15_jasmine",          "javascript-node_jasmine"),
    foundation("javascript-0.12.7_jasmine-2.3 ",      "javascript-node_jasmine"),
    no_version("javascript-node_jasmine-2.3",         "javascript-node_jasmine"),
    foundation("javascript-mocha",                    "javascript-node_mocha_chai_sinon"),
    foundation("javascript-0.10.25_mocha_chai_sinon", "javascript-node_mocha_chai_sinon"),
    foundation("javascript-0.12.7_qunit_sinon_chai",  "javascript-node_qunit_sinon"),

# Perl
    language("perl-5.14.2", "perl-5.18.2"),
    foundation("perl-5.14.2_test_simple", "perl_test_simple"),
    no_version("perl-5.18.2_test_simple", "perl_test_simple"),

# PHP
    language("php-5.5.3", "php-5.5.9"),
    foundation("php-5.5.3_phpunit", "php_phpunit"),
    no_version("php-5.5.9_phpunit", "php_phpunit"),

# Python
    language("python-3.3.5"),
    foundation("python-3.3.5_pytest", "python_pytest"),
    no_version("python-3.3.5_pytest", "python_pytest"),
    foundation("python-3.3.5_unittest", "python_unittest"),
    no_version("python-3.3.5_unittest", "python_unittest"),

# R
    language("r-3.0.1"),
    foundation("r-3.0.1_runit", "r_runit"),
    no_version("r-3.0.1_runit", "r_runit"),

# Ruby1.9.3
    language("ruby-1.9.3"),
    foundation("ruby-1.9.3_approval",  "ruby_approval"),
    no_version("ruby-1.9.3_approval",  "ruby_approval"),
    foundation("ruby-1.9.3_cucumber",  "ruby_cucumber"),
    no_version("ruby-1.9.3_cucumber",  "ruby_cucumber"),
    foundation("ruby-1.9.3_rspec",     "ruby_rspec"),
    no_version("ruby-1.9.3_rspec",     "ruby_rspec"),
    foundation("ruby-1.9.3_test_unit", "ruby_test_unit"),
    no_version("ruby-1.9.3_test_unit", "ruby_test_unit"),

# Ruby2.1.3
    language("ruby-2.1.3"),
    foundation("ruby-2.1.3_mini_test", "ruby_mini_test"),
    no_version("ruby-2.1.3_mini_test", "ruby_mini_test"),

# Rust
    language("rust-1.0.0", "rust-1.2.0"),
    foundation("rust-1.0.0_test", "rust_test"),
    no_version("rust-1.2.0_test", "rust_test"),

# Scala
    language("scala-2.9.2", "scala-2.11.7"),
    foundation("scala-2.9.2_scalatest",  "scala_scalatest"),
    no_version("scala-2.11.7_scalatest", "scala_scalatest"),

# VisualBasic
    language("visual_basic-0.5943"),
    foundation("visual_basic-0.5943_nunit", "visual-basic_nunit"),
    no_version("visual_basic-0.5943_nunit", "visual-basic_nunit")
  ]
end

def installed_images
  output = `docker images 2>&1`
  lines = output.split("\n").select { |line| line.start_with?('cyberdojo') }
  lines.collect { |line| line.split[0] }.sort.uniq
end

def ok_or_failed
  $?.exitstatus == 0 ? 'OK' : 'FAILED'
end

def update_images
  images = installed_images
  conversion.each do |old, new|
    if images.include?(old) && !images.include?(new)
      cmd = "docker pull #{new}"
      print cmd
      `#{cmd}`
      puts " --> #{ok_or_failed}"
      if $?.exitstatus == 0
        cmd = "docker rmi #{old}"
        print cmd
        `#{cmd}`
        puts " --> #{ok_or_failed}"
      end
    end
  end
end

def line
  '-' * 80
end

def cyberdojo_foundation_docker_update_all
  puts line
  puts 'Pulling latest images - this may take a while.'
  puts 'Languages being updated will *NOT* work till the'
  puts 'pull completes and the languages caches is refreshed.'
  update_images
  puts line
end