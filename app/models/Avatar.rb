root = '../..'
require_relative root + '/app/lib/Cleaner'
require_relative root + '/lib/TimeNow'

class Avatar

  def initialize(kata,name,externals)
    raise 'Invalid Avatar(name)' if !Avatars.valid?(name)
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
    json_lights.map { |inc| Light.new(self,inc) }
  end

  #- - - - - - - - - - - - - - -

  def test(delta, visible_files, time_limit = 15, now = time_now)
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

    output = clean(runner.run(sandbox, './cyber-dojo.sh', time_limit))
    sandbox.write('output', output) # so output appears in diff-view
    visible_files['output'] = output
    kata.language.after_test(sandbox, visible_files)
    save_manifest(visible_files)

    rags = json_lights
    rag = {
      'colour' => kata.language.colour(output),
      'time'   => now,
      'number' => rags.length + 1
    }
    rags << rag
    dir.write('increments.json', rags)
    commit(rags.length)

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

  include Cleaner
  include TimeNow

  def disk
    @externals[:disk]
  end

  def git
    @externals[:git]
  end

  def runner
    @externals[:runner]
  end

  def json_lights
    @json_lights ||= JSON.parse(clean(dir.read('increments.json')))
  end

end
