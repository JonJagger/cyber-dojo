
gem 'minitest'
require 'minitest/autorun'

require_relative './TestDomainHelpers'
require_relative './TestExternalHelpers'

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

  def self.dtor
    proc { warn_unseed_ids if unseen_ids != [] }
  end

  ObjectSpace.define_finalizer( self, dtor() )

  def self.warn_unseen_ids
    puts '>' * 35
    puts 'the following test ids were *not* found'
    puts "#{unseen_ids}"
    puts message
    puts '>' * 35
  end

  def self.unseen_ids
    @@args - @@seen
  end

  @@args = ARGV.sort.uniq - ['--']
  @@seen = []

end
