require 'forwardable'

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
    @kata,@name = kata,name
    @externals = externals
  end

  attr_reader :kata, :name

  def_delegators :kata, :format

  def path
    kata.path + name + '/'
  end

  def dir
    disk[path]
  end

  def exists?
    Avatar.names.include?(name) && dir.exists?
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

  def save(delta, visible_files)
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
  end

  def test(max_duration)
    output = runner.run(sandbox, './cyber-dojo.sh', max_duration)
    clean(output)
  end

  def save_manifest(visible_files)
    dir.write(visible_files_filename, visible_files)
  end

  def save_traffic_light(traffic_light, now)
    lights = traffic_lights
    lights << traffic_light
    traffic_light['number'] = lights.length
    traffic_light['time'] = now
    dir.write(traffic_lights_filename, lights)
    lights
  end

  def commit(tag)
    git.commit(path, "-a -m '#{tag}' --quiet")
    git.tag(path, "-m '#{tag}' #{tag} HEAD")
  end

  #- - - - - - - - - - - - - - -

  def lights
    Lights.new(self)
  end

  def traffic_lights(tag = nil)
    parse(traffic_lights_filename, tag)
  end

  #- - - - - - - - - - - - - - -

  def visible_files(tag = nil)
    parse(visible_files_filename, tag)
  end

  def diff_lines(was_tag, now_tag)
    command = "--ignore-space-at-eol --find-copies-harder #{was_tag} #{now_tag} sandbox"
    output = git.diff(path, command)
    clean(output)
  end

  def traffic_lights_filename
    'increments.' + format
  end

  def visible_files_filename
    'manifest.' + format
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

  def parse(filename, tag)
    raw = dir.read(filename)                   if tag == nil
    raw = git.show(path, "#{tag}:#{filename}") if tag != nil
    text = clean(raw)
    return JSON.parse(JSON.unparse(cleaned(filename,eval(text)))) if format === 'rb'
    return JSON.parse(text)                     if format === 'json'
  end

  def cleaned(filename,obj)
    if filename === 'manifest.rb'
      filenames = obj.keys
      filenames.each do |filename|
        s = obj[filename]
        obj[filename] = clean(s)
      end
    end
    obj
  end

  def clean(s)
    # force an encoding change - if encoding is already utf-8
    # then encoding to utf-8 is a no-op and invalid byte
    # sequences are not detected.
    s = s.encode('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
    s = s.encode('UTF-8', 'UTF-16')
  end

end
