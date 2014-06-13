require 'forwardable'
require 'Externals'

class Avatar
  extend Forwardable
  include Externals

  def initialize(kata, name)
    @kata,@name = kata,name
  end

  attr_reader :kata, :name

  def_delegators :kata, :format

  def path
    kata.path + name + '/'
  end

  def exists?
    Avatars.names.include?(name) && dir(path).exists?
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
    Sandbox.new(self)
  end

  def save(delta, visible_files)
    delta[:changed].each do |filename|
      dir(sandbox.path).write(filename, visible_files[filename])
    end
    delta[:new].each do |filename|
      dir(sandbox.path).write(filename, visible_files[filename])
      git.add(sandbox.path, filename)
    end
    delta[:deleted].each do |filename|
      git.rm(sandbox.path, filename)
    end
  end

  def test(max_duration)
    output = runner.run(sandbox, './cyber-dojo.sh', max_duration)
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def save_visible_files(visible_files)
    dir(path).write(visible_files_filename, visible_files)
  end

  def save_traffic_light(traffic_light, now)
    lights = traffic_lights
    lights << traffic_light
    traffic_light['number'] = lights.length
    traffic_light['time'] = now
    dir(path).write(traffic_lights_filename, lights)
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
    output.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace)
  end

  def traffic_lights_filename
    'increments.' + format
  end

  def visible_files_filename
    'manifest.' + format
  end

private

  def parse(filename, tag)
    text = dir(path).read(filename) if tag == nil
    text = git.show(path, "#{tag}:#{filename}") if tag != nil
    return JSON.parse(JSON.unparse(eval(text))) if format === 'rb'
    return JSON.parse(text) if format === 'json'
  end

end
