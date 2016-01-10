require 'digest/md5'

# Adds hex-id to each test so the id can be
# used to selectively run specific tests.

module TestHexIdHelpers # mix-in

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    @@args = (ARGV.sort.uniq - ['--']).map(&:upcase)  # eg  2DD6F3 or 2dd
    @@seen = []

    def test(id = nil, name, &block)
      line = 'X' * 35
      id ||= Digest::MD5.hexdigest(name).upcase[0..5]
      if id == ''
        puts
        puts line
        puts "test '', is missing it's uuid"
        puts "#{name}"
        puts line
        puts
        raise "test '',..."
      end
      if @@args == [] || @@args.any?{ |arg| id.include?(arg) }
        if @@seen.include?(id)
          puts
          puts line
          puts "test with id #{id} has already been seen"
          puts "#{name}"
          puts line
          puts
        else
          @@seen << id
          define_method("test_ '#{id}',\n #{name}\n".to_sym, &block)
        end
      end
    end

    ObjectSpace.define_finalizer(self, proc {
      seen_args = @@args.find_all { |arg| @@seen.any? { |id| id.include?(arg) } }
      unseen_args = @@args - seen_args
      if unseen_args != []
        line = 'X' * 35
        puts
        puts line
        puts 'the following test id arguments were *not* found'
        puts "#{unseen_args}"
        puts line
        puts
      end
    })

  end

end
