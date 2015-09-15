
gem 'minitest'
require 'minitest/autorun'

require_relative './TestDomainHelpers'
require_relative './TestExternalHelpers'
require_relative './TestWithId'

class TestBase < MiniTest::Test
  
  include TestDomainHelpers
  include TestExternalHelpers

  def self.test(id='343434',name,&block)
    if @@args==[] || @@args.include?(id)
      @@seen << id
      define_method("test__[#{id}]__#{name}".to_sym, &block)
    end
  end

private

  # TODO: somehow get this called in class.finalizer
  def finalize
    proc { warning("tests#{unseen_ids} not found") if unseen_ids != [] }
  end

  def warning(message)
    puts '>' * 35
    puts message
    puts '>' * 35
  end

  def unseen_ids
    @@args - @@seen
  end

  @@args = ARGV.sort.uniq - ['--']
  @@seen = []

end
