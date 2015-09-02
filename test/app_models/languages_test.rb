#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'

class LanguagesTests < ModelTestBase

  test 'path is set from ENV' do
    path = 'end_with_slash/'
    set_languages_root(path)  
    assert_equal path, languages.path
    assert path_ends_in_slash?(languages)
    assert path_has_no_adjacent_separators?(languages)    
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'path is forced to end in a slash' do
    path = 'unslashed'
    set_languages_root(path)  
    assert_equal path+'/', languages.path
    assert path_ends_in_slash?(languages)
    assert path_has_no_adjacent_separators?(languages)    
  end
  
  #- - - - - - - - - - - - - - - - - - - - -

  test 'refresh_cache requires manifest.json for each file to read display_name from' do
    set_disk_class_name('DiskFake')
    runey = languages['R-runey']
    runey.dir.write('manifest.json',
      {
        'display_name' => 'R,Rooney'
      }
    )
    languages.refresh_cache
    languages_names = languages.map {|language| language.name }.sort
    assert_equal ['R-Rooney'], languages_names
    assert_equal 'R',        runey.dir_name
    assert_equal 'runey',    runey.test_dir_name
    assert_equal 'R,Rooney', runey.display_name
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'no languages when cache is empty' do
    languages.dir.write('cache.json', cache={})
    assert_equal [], languages.to_a
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'languages from cache when cache is not empty' do
    cache = {
      'Asm, assert' => {
        :dir_name => 'Asm', 
        :test_dir_name => 'assert'
      },
      'C++ (g++), assert' => {
        :dir_name => 'g++4.8.4',
        :test_dir_name => 'assert'        
      }
    }
    languages.dir.write('cache.json', cache)
    languages_names = languages.map {|language| language.name }.sort

    assert_equal ['Asm-assert', 'C++ (g++)-assert'], languages_names

    assert_equal 'Asm, assert', languages['Asm-assert'].display_name
    assert_equal 'Asm',         languages['Asm-assert'].dir_name
    assert_equal 'assert',      languages['Asm-assert'].test_dir_name
    
    assert_equal 'C++ (g++), assert', languages['C++ (g++)-assert'].display_name
    assert_equal 'g++4.8.4',          languages['C++ (g++)-assert'].dir_name
    assert_equal 'assert',            languages['C++ (g++)-assert'].test_dir_name    
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'languages[X] is language named X' do
    ['C (gcc)-assert','C#-NUnit'].each do |name|
      assert_equal name, languages[name].name
    end
  end

  #- - - - - - - - - - - - - - - - - - - - -

  test 'name is translated when katas manifest.json language entry has been renamed' do  
    historical_language_names do |old_name|
      new_name = languages.renamed(old_name)
      assert exists?(*new_name), old_name
    end    
  end

  #- - - - - - - - - - - - - - - - - - - - -
  
  def historical_language_names
    # these names harvested from cyber-dojo.org using
    # admin_scripts/show_kata_language_names.rb
    #
    # katas/../......../manifest.json { language: X }
    # Also listed are count of occurences on cyber-dojo.org
    # and ID of one occurrence on cyber-dojo.org
    [
      "Asm-assert 25 010E66019D",  
      "BCPL 3 DF9A083C0F",
      "BCPL-all_tests_passed 18 C411C2351E",
      "C 479 54529AA3BE",
      "C# 1473 54F993C99A",
      "C#-NUnit 3088 54009537D3",
      "C#-SpecFlow 229 543E10EB15",
      "C++ 535 54E041DECA",
      "C++-Boost.Test 55 54C6A3B75B",
      "C++-Catch 352 54652F82AD",
      "C++-CppUTest 662 54A93BB04C",
      "C++-GoogleMock 19 280B752660",
      "C++-GoogleTest 1452 54C157173A",
      "C++-Igloo 46 280DB28223",
      "C++-assert 1015 545111471C",
      "C-Unity 450 5498403AF6",
      "C-assert 836 54B99F4CE2",
      "Clojure 67 5A53D42987",
      "Clojure-.test 177 546B4184B4",
      "CoffeeScript 47 014F4190E0",
      "CoffeeScript-jasmine 83 54219ECA71",
      "D-unittest 45 541349CE61",
      "Erlang 45 282F687601",
      "Erlang-eunit 121 543F979F1C",
      "F#-NUnit 101 5447BFDCB0",
      "Fortran-FUnit 64 016105DBCD",
      "Go 47 AA393DDF4B",
      "Go-testing 155 2849773A9C",
      "Groovy-JUnit 117 5A776302BC",
      "Groovy-Spock 109 AADE304AC9",
      "Haskell 81 23939E0066",
      "Haskell-hunit 146 28894CFFC1",
      "Java 17 23A7CF3454",
      "Java-1.8_Approval 389 54D58851FE",
      "Java-1.8_Cucumber 228 54303D90C6",
      "Java-1.8_JMock 43 C484782160",
      "Java-1.8_JUnit 3648 5437D7B510",
      "Java-1.8_Mockito 313 540E06E467",
      "Java-1.8_Powermockito 56 339F6FF85A",
      "Java-Approval 220 54624C174C",
      "Java-Cucumber 163 543D714DF5",
      "Java-JUnit 1708 54FB5612C3",
      "Java-JUnit-Mockito 160 54359DB8B5",
      "Java-Mockito 37 020B8A969E",
      "Java-PowerMockito 6 D360343B60",
      "Javascript 474 54210DA681",
      "Javascript-assert 517 549D533F36",
      "Javascript-jasmine 534 5A749EFF33",
      "Javascript-mocha_chai_sinon 128 5A405D8EE2",
      "PHP 396 54C77C53AA",
      "PHP-PHPUnit 827 541E1B649B",
      "Perl 57 549C58C8BA",
      "Perl-TestSimple 112 287BE6DEDB",
      "Python 621 54F07B407C",
      "Python-pytest 815 5496730F04",
      "Python-unittest 1242 548F3E67A7",
      "R-RUnit 37 54811DAFB1",
      "R-stopifnot 2 F0A5407B87",
      "Ruby 339 54EE119F79",
      "Ruby-Approval 149 283E57E66D",
      "Ruby-Cucumber 154 28A62BD7AA",
      "Ruby-Rspec 508 545144CA06",
      "Ruby-TestUnit 412 546A3CCA40",
      "Scala-scalatest 190 5A3EE246D6",
    ].each do |entry|
      yield entry.split[0]
    end
  end

  def exists?(lang,test)
    File.directory?("#{cyber_dojo_root}/languages/#{lang}/#{test}") ||
    File.directory?("#{cyber_dojo_root}/languages_offline/#{lang}/#{test}")        
  end

  def cyber_dojo_root
    Dir.pwd + '/../..'
  end

end
