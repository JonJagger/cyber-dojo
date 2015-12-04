require 'fileutils'

class HostDir

  def initialize(disk, path)
    @disk = disk
    @path = path
    @path += separator unless @path.end_with?(separator)
  end

  attr_reader :path

  def each_dir
    return enum_for(:each_dir) unless block_given?
    Dir.entries(path).each do |entry|
      pathed = path + entry
      yield entry if @disk.dir?(pathed) && !dot?(pathed)
    end
  end

  def each_file
    return enum_for(:each_file) unless block_given?
    Dir.entries(path).each do |entry|
      pathed = path + entry
      yield entry unless @disk.dir?(pathed)
    end
  end

  def exists?(filename = nil)
    return File.directory?(path) if filename.nil?
    return File.exists?(path + filename)
  end

  def make
    # -p creates intermediate dirs as required.
    FileUtils.mkdir_p(path)
  end

  def write_json(filename, object)
    fail RuntimeError.new("#{filename} doesn't end in .json") unless filename.end_with? '.json'
    write(filename, JSON.unparse(object))
  end

  def write(filename, s)
    fail RuntimeError.new('not a string') unless s.is_a? String
    pathed_filename = path + filename
    File.open(pathed_filename, 'w') { |fd| fd.write(s) }
    File.chmod(0755, pathed_filename) if pathed_filename.end_with?('.sh')
  end

  def read_json(filename)
    fail RuntimeError.new("#{filename} doesn't end in .json") unless filename.end_with? '.json'
    JSON.parse(read(filename))
  end

  def read(filename)
    clean(IO.read(path + filename))
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # This needs to be separated out to a dedicated service.
  # When storage is via network then locking on a file like
  # this is no good. It is used only in one place - to ensure
  # two laptops don't get the same avatar.
  #
  # 1. app/models/Kata.rb start_avatar()
  # 2. app/models/Avatars.rb started_avatars()
  #
  # I'm thinking I can instead use Google's networked object store.
  # This has an api allowing optimistic locking.
  # One approach: save the full list of 64 avatar names into
  # an object associated with the dojo's id. Then start() retrieves
  # this 'unstarted' list. If its empty the dojo is full. Otherwise
  # pick an avatar and try to delete it from the list. If delete
  # succeeds you have that avatar atomically and can initialize its
  # files in the katas file system volume. If delete fails then retry.
  # With this approach the collective information of what avatars
  # have started is [all-avatar-names] - [unstarted-list].
  #
  # What I don't like about this approach is that it splits the
  # state... the object on the network store mirrors the folder
  # on the katas/ volume.

  def lock(&block)
    result = nil
    File.open(path + 'f.lock', 'w') do |fd|
      if fd.flock(File::LOCK_EX)
        begin
          result = block.call
        ensure
          fd.flock(File::LOCK_UN)
        end
      end
    end
    result
  end

  private

  include StringCleaner

  def dot?(name)
    name.end_with?('/.') || name.end_with?('/..')
  end

  def separator
    @disk.dir_separator
  end

end
