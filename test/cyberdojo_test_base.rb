
require_relative 'test_coverage'
require_relative 'all'
require 'test/unit'

# used only by
# test/languages/
# test/lib

class CyberDojoTestBase < Test::Unit::TestCase

  def root_path
    File.expand_path('..', File.dirname(__FILE__)) + '/'
  end

  def setup
    `rm -rf #{root_path}test/cyberdojo/katas/*`
  end

  def self.test(name, &block)
    define_method("test_#{name}".to_sym, &block)
  end

end
