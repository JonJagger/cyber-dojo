require 'forwardable'
require_relative '../lib/Cleaner'

class Avatar
  extend Forwardable

  def self.names
      # no two names start with the same letter
      %w(
          alligator buffalo cheetah deer
          elephant frog gorilla hippo
          koala lion moose panda
          raccoon snake wolf zebra
        )
  end

  def initialize(kata,name,externals)
    raise 'Invalid Avatar(name)' if !valid?(name)
    @kata,@name,@externals = kata,name,externals
  end

  attr_reader :kata, :name

  def path
    kata.path + name + '/'
  end

  def dir
    disk[path]
  end

  def exists?
    #Avatar.names.include?(name) && dir.exists?
    dir.exists?
  end

  def active?
    # o) Players commonly start two avatars on the same computer and use
    #    one solely to read the instructions. I don't want these avatars
    #    appearing on the dashboard.
    # o) When an avatar enters a cyber-dojo the tests are automatically
    #    run. This means an avatar gets one traffic-light for free.
    # o) When forking a new kata it is common to enter as one animal
    #    to sanity check it is ok (but not press [test])
    exists? && lights.count > 1
  end

  def sandbox
    Sandbox.new(self,disk)
  end

  #- - - - - - - - - - - - - - -

  def tags
    @tags ||= Tags.new(self,git)
  end

  def lights
    Lights.new(self)
  end

  #- - - - - - - - - - - - - - -

  def test(delta, visible_files, max_duration, now)
    delta[:changed].each do |filename|
      sandbox.dir.write(filename, visible_files[filename])
    end
    delta[:new].each do |filename|
      sandbox.dir.write(filename, visible_files[filename])
      git.add(sandbox.path, filename)
    end
    delta[:deleted].each do |filename|
      git.rm(sandbox.path, filename)
    end

    output = clean(runner.run(sandbox, './cyber-dojo.sh', max_duration))
    sandbox.write('output', output) # so output appears in diff-view
    visible_files['output'] = output

    rags = lights.each.entries
    rag = {
      'colour' => kata.language.colour(output),
      'time' => now,
      'number' => rags.length + 1
    }
    rags << rag
    dir.write('increments.json', rags)
    rags
  end

  def save_manifest(visible_files)
    dir.write('manifest.json', visible_files)
  end

  def commit(tag)
    git.commit(path, "-a -m '#{tag}' --quiet")
    git.tag(path, "-m '#{tag}' #{tag} HEAD")
  end

private

  def disk
    @externals[:disk]
  end

  def git
    @externals[:git]
  end

  def runner
    @externals[:runner]
  end

  def valid?(name)
    Avatar.names.include?(name)
  end

  include Cleaner

end
