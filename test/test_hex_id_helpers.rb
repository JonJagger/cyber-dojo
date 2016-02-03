
# Uses hex-id on each test to selectively run specific tests.

module TestHexIdHelpers # mix-in

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    @@args = (ARGV.sort.uniq - ['--']).map(&:upcase)  # eg  2DD6F3 eg 2dd
    @@seen_ids = []

    def test(id, *lines, &block)
      diagnostic = "'#{id}',#{lines.join}"
      hex_chars = '0123456789ABCDEF'
      is_hex_id = id.chars.all? { |ch| hex_chars.include? ch }
      has_empty_line = lines.any? { |line| line.strip == '' }
      has_space_line = lines.any? { |line| line.strip != line }
      raise  "no hex-ID: #{diagnostic}" if id == ''
      raise "bad hex-ID: #{diagnostic}" unless is_hex_id
      raise "empty line: #{diagnostic}" if has_empty_line
      raise "space line: #{diagnostic}" if has_space_line
      no_args = @@args == []
      any_arg_is_part_of_id = @@args.any?{ |arg| id.include?(arg) }
      if no_args || any_arg_is_part_of_id
        raise "duplicate hex_ID: #{diagnostic}" if @@seen_ids.include?(id)
        @@seen_ids << id
        name = lines.join(' ')
        define_method("test_'#{id}',\n #{name}\n".to_sym, &block)
      end
    end

    ObjectSpace.define_finalizer(self, proc {
      unseen_arg = lambda { |arg| @@seen_ids.none? { |id| id.include?(arg) } }
      unseen_args = @@args.find_all { |arg| unseen_arg.call(arg) }
      if unseen_args != []
        # can't raise in a finalizer
        message = 'the following test id arguments were *not* found'
        bar = 'X' * message.length
        lines = [ '', bar, message, "#{unseen_args}", bar, '' ]
        lines.each { |line| puts line }
      end
    })

  end

end
