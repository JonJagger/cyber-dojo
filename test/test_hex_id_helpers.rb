
# Uses hex-id on each test to selectively run specific tests.

module TestHexIdHelpers # mix-in

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    @@args = (ARGV.sort.uniq - ['--']).map(&:upcase)  # eg  2DD6F3 or 2dd
    @@seen = []

    def test(id, *lines, &block)
      diagnostic = "'#{id}',#{lines.join}"
      hex_chars = "0123456789ABCDEF"
      hex_id = lambda { id.chars.all? { |ch| hex_chars.include? ch } }
      spaced_line = lambda { lines.any? { |line| line.strip != line } }
      empty_line = lambda { lines.any? { |line| line.strip == '' }}

      raise "no hex-ID: #{diagnostic}" unless id != ''
      raise "bad hex-ID: #{diagnostic}" unless hex_id.call
      raise "empty name line: #{diagnostic}" if empty_line.call
      raise "lead/trail spaces: #{diagnostic}" if spaced_line.call

      if @@args == [] || @@args.any?{ |arg| id.include?(arg) }
        if @@seen.include?(id)
          raise "duplicate hex_ID: #{diagnostic}"
        else
          @@seen << id
          name = lines.join(' ')
          define_method("test_ '#{id}',\n #{name}\n".to_sym, &block)
        end
      end
    end

    ObjectSpace.define_finalizer(self, proc {
      seen_args = @@args.find_all { |arg| @@seen.any? { |id| id.include?(arg) } }
      unseen_args = @@args - seen_args
      if unseen_args != []
        # can't raise in a finalizer
        message = 'the following test id arguments were *not* found'
        line = 'X' * message.length
        puts
        puts line
        puts message
        puts "#{unseen_args}"
        puts line
        puts
      end
    })

  end

end
