require 'digest/md5'

module TestHexIdHelpers # mix-in
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods

    @@args = ARGV.sort.uniq - ['--']
    @@seen = []

    def test(id = nil, name, &block)
      id ||= Digest::MD5.hexdigest(name).upcase[0..5]
      if @@args==[] || @@args.include?(id)
        if @@seen.include?(id)
          line = 'X' * 35
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
      unseen_ids = @@args - @@seen
      if unseen_ids != []
        line = 'X' * 35
        puts
        puts line
        puts 'the following test ids were *not* found'
        puts "#{unseen_ids}"
        puts line
        puts
      end
    })

  end

end
