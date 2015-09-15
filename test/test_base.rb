
gem 'minitest'
require 'minitest/autorun'
require 'digest/md5'

require_relative './TestDomainHelpers'
require_relative './TestExternalHelpers'

class TestBase < MiniTest::Test
  
  include TestDomainHelpers
  include TestExternalHelpers

  # TODO: duplicated in test/app_controllers/controller_test_base.rb
  #       capture duplication in abstraction

  def self.test(id = hex_hash(name), name, &block)
    if @@args==[] || @@args.include?(id)
      @@seen << id
      define_method("test_ '#{id}',\n#{name}\n".to_sym, &block)
    end
  end

private

  def self.hex_hash(name)
    Digest::MD5.hexdigest(name).upcase[0..5]
  end

  def self.dtor
    proc {
      if unseen_ids != []
        line = 'X' * 35
        puts
        puts line
        puts 'the following test ids were *not* found'
        puts "#{unseen_ids}"
        puts line
        puts
      end
    }
  end

  ObjectSpace.define_finalizer( self, dtor() )

  def self.unseen_ids
    @@args - @@seen
  end

  @@args = ARGV.sort.uniq - ['--']
  @@seen = []

end
