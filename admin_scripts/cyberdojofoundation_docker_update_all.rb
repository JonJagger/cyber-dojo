#!/usr/bin/env ruby
#Comments at end of file

require 'json'

class LanguageUpdater

  def initialize()
    @installed = installed_images_names
    @masters = manifest_images_names
  end

  def delete_dead_images
    # [docker rmi]s existing images if they are defunct where
    # defunct means they do not appear in the conversion table
    # anywhere, new OR old. This is to reduce time when the
    # server's state is wrong. image_names that appear as old
    # names are handled in upgrade_to_new_images which only
    # deletes the old image once the new one is pulled.
    display line
    display 'Looking for dead images'
    conversion = conversion_images_names('old','new')
    installed.each do |image_name|
      docker_rmi(image_name) if !conversion.include?(image_name) && !masters.include?(image_name)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def update_existing_images
    # [docker pull]s existing image_names if they are current masters.
    # Even if the image is not actually pulled it can take a second
    # or so to check each image.
    display line
    display 'Updating existing images'
    conversion = conversion_images_names('new')
    installed.each do |image_name|
      docker_pull(image_name) if conversion.include?(image_name)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def upgrade_to_new_images
    display line
    display 'Checking for new images - this may take a while.'
    display 'New languages will *NOT* appear in cyber-dojo until their'
    display 'pull completes and the languages cache is refreshed.'
    masters = manifest_images_names
    conversion.each do |old_name, new_name|
      if installed.include?(old_name) && !installed.include?(new_name) && masters.include?(new_name)
        if docker_pull(new_name)
          docker_rmi(old_name)
        end
      end
    end
    puts line
  end

  private  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  attr_reader :installed, :masters

  def installed_images_names
    output, _ = run('docker images 2>&1')
    lines = output.split("\n").select { |line| line.start_with?('cyberdojo') }
    lines.collect { |line| line.split[0] }.sort.uniq
  end

  def manifest_images_names
    images_names = []
    cyber_dojo_root = '/var/www/cyber-dojo'
    Dir.glob("#{cyber_dojo_root}/languages/*/*/manifest.json") do |filename|
      manifest = JSON.parse(IO.read(filename))
      images_names << manifest['image_name']
    end
    images_names.sort
  end

  def conversion_images_names(*names)
    images_names = []
    conversion.each do |old_name, new_name|
      images_names << old_name if names.include?('old')
      images_names << new_name if names.include?('new')
    end
    images_names.sort.uniq
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def docker_pull(image_name)
    display_and_run("docker pull #{image_name}")
  end

  def docker_rmi(image_name)
    display_and_run("docker rmi  #{image_name}")
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def display_and_run(command)
    print command
    _, exit_status = run(command)
    ok_or_failed = exit_status == 0 ? 'OK' : 'FAILED'
    display " --> #{ok_or_failed}"
    return exit_status == 0
  end

  def display(string)
    puts string
  end

  def run(command)
    output = `#{command}`
    return output, $?.exitstatus
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def conversion
    [
  # Asm
      foundation("nasm-2.10.0_assert",  "nasm_assert"),
      no_version("nasm-2.10.09_assert", "nasm_assert"),

  # Bash
      foundation("bash_shunit2"),

  # BCPL
      foundation("bcpl-all_tests_passed"),

  # C#
      foundation("csharp-2.10.8.1_nunit",    "csharp_nunit"),
      no_version("csharp-2.10.8.1_nunit",    "csharp_nunit"),
      foundation("csharp-2.10.8.1_specflow", "csharp_specflow"),
      no_version("csharp-2.10.8.1_specflow", "csharp_specflow"),

  # C (clang)
      foundation("clang-3.6.1_assert", "clang_assert"),
      no_version("clang-3.6.1_assert", "clang_assert"),

  # C (gcc)
      foundation("gcc-4.8.1_assert",   "gcc_assert"),
      no_version("gcc-4.8.4_assert",   "gcc_assert"),
      foundation("gcc-4.8.1_cpputest", "gcc_cpputest"),
      no_version("gcc-4.8.4_cpputest", "gcc_cpputest"),
      foundation("gcc-4.8.1_unity",    "gcc_unity"),
      no_version("gcc-4.8.4_unity",    "gcc_unity"),

  # C++ (clang++)
      foundation("clang-3.6.0_assert",     "clangpp_assert"),
      no_version("clang-3.6.0_assert",     "clangpp_assert"),
      foundation("clang-3.6.0_googletest", "clangpp_googletest"),
      no_version("clang-3.6.0_googletest", "clangpp_googletest"),

  # C++ (g++) 4.8.4
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
      foundation("clojure-1.4.0_test"),

  # CoffeeScript
      foundation("coffeescript-1.14.3_jasmine", "coffeescript_jasmine"),
      no_version("coffeescript-1.14.3_jasmine", "coffeescript_jasmine"),

  # D
      foundation("d-4.8.1_unittest", "d_unittest"),
      no_version("d-4.8.4_unittest", "d_unittest"),

  # Erlang
      foundation("erlang-5.10.2_eunit", "erlang_eunit"),
      no_version("erlang-5.10.4_eunit", "erlang_eunit"),

  # F#
      foundation("fsharp-3.0_nunit", "fsharp_nunit"),
      no_version("fsharp-3.0_nunit", "fsharp_nunit"),

  # Fortran
      foundation("fortran-4.8_funit",   "fortra_funit"),
      no_version("fortran-4.8.4_funit", "fortran_funit"),

  # Go
      foundation("go-1.1.2_testing", "go_testing"),
      no_version("go-1.2.1_testing", "go_testing"),

  # Groovy
      foundation("groovy-2.2.0_junit", "groovy_junit"),
      no_version("groovy-2.4.4_junit", "groovy_junit"),
      foundation("groovy-2.2.0_spock", "groovy_spock"),
      no_version("groovy-2.4.4_spock", "groovy_spock"),

  # Haskell
      foundation("haskell-7.6.3_hunit", "haskell_hunit"),
      no_version("haskell-7.6.3_hunit", "haskell_hunit"),

  # Java
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
      foundation("javascript-0.10.15_assert",           "javascript-node_assert"),
      foundation("javascript-0.10.25_assert",           "javascript-node_assert"),
      foundation("javascript-0.10.15_jasmine",          "javascript-node_jasmine"),
      foundation("javascript-0.12.7_jasmine-2.3 ",      "javascript-node_jasmine"),
      no_version("javascript-node_jasmine-2.3",         "javascript-node_jasmine"),
      foundation("javascript-mocha",                    "javascript-node_mocha_chai_sinon"),
      foundation("javascript-0.10.25_mocha_chai_sinon", "javascript-node_mocha_chai_sinon"),
      foundation("javascript-0.12.7_qunit_sinon_chai",  "javascript-node_qunit_sinon"),

  # Perl
      foundation("perl-5.14.2_test_simple", "perl_test_simple"),
      no_version("perl-5.18.2_test_simple", "perl_test_simple"),

  # PHP
      foundation("php-5.5.3_phpunit", "php_phpunit"),
      no_version("php-5.5.9_phpunit", "php_phpunit"),

  # Python
      foundation("python-3.3.5_pytest", "python_pytest"),
      no_version("python-3.3.5_pytest", "python_pytest"),
      foundation("python-3.3.5_unittest", "python_unittest"),
      no_version("python-3.3.5_unittest", "python_unittest"),

  # R
      foundation("r-3.0.1_runit", "r_runit"),
      no_version("r-3.0.1_runit", "r_runit"),

  # Ruby1.9.3
      foundation("ruby-1.9.3_approval",  "ruby_approval"),
      no_version("ruby-1.9.3_approval",  "ruby_approval"),
      foundation("ruby-1.9.3_cucumber",  "ruby_cucumber"),
      no_version("ruby-1.9.3_cucumber",  "ruby_cucumber"),
      foundation("ruby-1.9.3_rspec",     "ruby_rspec"),
      no_version("ruby-1.9.3_rspec",     "ruby_rspec"),
      foundation("ruby-1.9.3_test_unit", "ruby_test_unit"),
      no_version("ruby-1.9.3_test_unit", "ruby_test_unit"),

  # Ruby2.1.3
      foundation("ruby-2.1.3_mini_test", "ruby_mini_test"),
      no_version("ruby-2.1.3_mini_test", "ruby_mini_test"),

  # Rust
      foundation("rust-1.0.0_test", "rust_test"),
      no_version("rust-1.2.0_test", "rust_test"),

  # Scala
      foundation("scala-2.9.2_scalatest",  "scala_scalatest"),
      no_version("scala-2.11.7_scalatest", "scala_scalatest"),

  # VisualBasic
      foundation("visual_basic-0.5943_nunit", "visual-basic_nunit"),
      no_version("visual_basic-0.5943_nunit", "visual-basic_nunit")
    ]
  end

  def foundation(old_name, new_name = old_name)
    [ "cyberdojo/" + old_name , "#{cdf}/" + new_name  ]
  end

  def no_version(old_name, new_name)
    fail "no_version(#{old_name} == #{new_name})" if old_name == new_name
    [ "#{cdf}/" + old_name , "#{cdf}/" + new_name  ]
  end

  def cdf
    'cyberdojofoundation'
  end

  def line
    '-' * 80
  end

end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

def cyberdojo_foundation_docker_update_all
  # Called from languages/refresh_cache.rb
  updater = LanguageUpdater.new()
  updater.delete_dead_images
  #updater.update_existing_images
  updater.upgrade_to_new_images
end

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# It's likely there is not enough disk space pull lots of new
# images and then remove all the old ones.
#
# Even if there was its not a great strategy because this script
# runs *after* [git pull]. So if you update all the image_name's in the
# languages' manifest.json files there will be long period of time
# (when lots of new images are being pulled) when the server's state is
# wrong - the image_names in the manifest.json files will not yet exist
# but the languages will still be present in the language cache.
#
# In this situation git checkout one language at a time.
# e.g., if the branch with the new image_names is called new-images
#       and it contains image_name update for Rust then
#
#   $ cd /var/www/cyber-dojo
#   $ git checkout master
#   $ git checkout new-images languages/Rust/*
#   $ ./languages/refresh_cache.rb
#
# will reduce the amount of time when the server's state is wrong to
# the time from the [git pull] (which is when new manifest.json image_names
# can appear) to the time when the [docker pull] completes and the
# language cache is refreshed (which is when the new manifest.json
# image_names become live).
#
# Then repeat for the other languages, one at a time.

