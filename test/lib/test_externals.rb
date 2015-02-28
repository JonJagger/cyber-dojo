#!/usr/bin/env ruby

require_relative 'lib_test_base'

class ExternalsTests < LibTestBase

  include ExternalSetter
  include ExternalDiskDir
  include ExternalGit
  include ExternalRunner
  include ExternalExercisesPath
  include ExternalLanguagesPath
  include ExternalKatasPath

  def setup
    symbols.each { |symbol|
      unset_external(symbol)
    }
  end

  def path
    'fubar/'
  end

  test 'raises RuntimeError if not set' do
    symbols.each do |symbol|
      error = assert_raises(RuntimeError) { self.send(symbol) }
      assert error.message.include? 'no external(:' + symbol.to_s
    end
  end

  test 'reset sets unconditionally' do
    non_path_symbols.each do |symbol| 
      reset_external(symbol, Object.new)
      assert_equal 'Object', self.send(symbol).class.name
      reset_external(symbol, Hash.new)
      assert_equal 'Hash', self.send(symbol).class.name    
    end        
  end

  test 'set sets only if not set already' do
    non_path_symbols.each do |symbol| 
      set_external(symbol, Object.new)
      assert_equal 'Object', self.send(symbol).class.name
      set_external(symbol, Hash.new)
      assert_equal 'Object', self.send(symbol).class.name    
    end        
  end
  
  test 'setting pathed symbols adds trailing slash if not present' do
    path_symbols.each do |symbol|
      set_external(symbol, 'wibble')
      assert_equal 'wibble/', external(symbol)
    end
  end
  
  test 'dir is disk[path]' do
    reset_external(:disk, DiskFake.new)
    assert_equal path, dir.path
  end

  def non_path_symbols
    [:disk,:git,:runner]
  end

  def path_symbols
    [:exercises_path,:languages_path,:katas_path]
  end
    
  def symbols
    non_path_symbols + path_symbols
  end
  
end
