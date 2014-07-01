require 'json'
require 'Cleaner'

class Tag

  def initialize(avatar,n,git)
    @avatar,@n,@git = avatar,n,git
  end

  def visible_files
    @vis ||= JSON.parse(clean(@git.show(@avatar.path, "#{@n}:manifest.json")))
  end

  def output
    # tag 0 does not have an output file
    visible_files['output'] || ''
  end

  def diff(m)
    command = "--ignore-space-at-eol --find-copies-harder #{@n} #{m} sandbox"
    clean(@git.diff(@avatar.path, command))
  end

private

  include Cleaner

end
