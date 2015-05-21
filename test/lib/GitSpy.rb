
class GitSpy

  def initialize(dojo=nil)
    @log = { }
    @stubs = { }
  end

  def log
    @log
  end

  def init(path, options)
    record(path, 'init', options)
  end

  def config(path, options)
    record(path, 'config', options)
  end

  def add(path, what)
    record(path, 'add', what)
  end

  def rm(path, what)
    record(path, 'rm', what)
  end

  def commit(path, options)
    record(path, 'commit', options)
  end

  def gc(path, options)
    record(path, 'gc', options)
  end

  def tag(path, options)
    record(path, 'tag', options)
  end

  def show(path, options)
    record(path, 'show', options)
    stub(path,'show',options)
  end

  def diff(path, options)
    record(path, 'diff', options)
    stub(path,'diff',options)
  end

  def spy(path, command, options, stub)
    tuple = [path,command,options]
    @stubs[tuple] = stub
  end

private

  def record(path, command, options)
    @log[path] ||= [ ]
    @log[path] << [command, options]
    "{ :hack => 'yes' }"
  end

  def stub(path, command, options)
    tuple = [path,command,options]
    @stubs[tuple]
  end

end
