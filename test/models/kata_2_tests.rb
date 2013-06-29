require File.dirname(__FILE__) + '/../test_helper'

class StubDiskFile
  
  def initialize
    @read_log = { }
    @write_log = { }
  end
  
  def read_log
    #puts @stub_file.read_log[dir].join("\n")    
    @read_log
  end
  
  def write_log
    @write_log
  end
  
  def separator
    '/'
  end
  
  def id
    '45ED23A2F1'
  end
  
  def kata_manifest
    {
      :id => id,
      :created => [2013,6,29,14,24,51],
      :unit_test_framework => 'verdal',
      :exercise => 'March Hare',
      :language => 'Carroll',
      :visible_files => {
        'name' => 'content for name'
      }
    }
  end
    
  def read(dir, filename)
    @read_log[dir] ||= [ ]
    @read_log[dir] << [filename]
    if filename == 'manifest.rb'
      return kata_manifest.inspect
    end
    return nil
  end
  
  def write(dir, filename, object)
    @write_log[dir] ||= [ ]
    @write_log[dir] << [filename, object.inspect]    
  end
  
end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

class StubDiskGit
  
  def initialize
    @log = { }
  end
  
  def log
    @log
  end
  
  def init(dir, options)
    store(dir, 'init', options)
  end
  
  def add(dir, what)
    store(dir, 'add', what)
  end
  
  def commit(dir, options)
    store(dir, 'commit', options)
  end
  
  def tag(dir, options)
    store(dir, 'commit', options)
  end
  
private

  def store(dir, command, options)
    @log[dir] ||= [ ]
    @log[dir] << [command, options]
  end
    
end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

class Kata2Tests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    Thread.current[:file] = @stub_file
    @stub_git = StubDiskGit.new
    Thread.current[:git] = @stub_git
  end

  def teardown
    Thread.current[:file] = nil
    Thread.current[:git] = nil
  end

  def root_dir
    (Rails.root + 'test/cyberdojo').to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "creation saves manifest in kata dir" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    
    assert_equal [ [ 'manifest.rb', info.inspect ] ], @stub_file.write_log[kata.dir]    
    assert_equal nil, @stub_file.read_log[kata.dir]
  end

  test "id property is from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal info[:id], kata.id    
  end
  
  test "created property is from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal Time.mktime(*info[:created]), kata.created    
  end
  
  test "age_in_seconds property is set from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    now = info[:created]
    seconds = 5
    now = now[0...-1] + [now.last + seconds ]
    assert_equal seconds, kata.age_in_seconds(Time.mktime(*now))    
  end
  
  test "language is set from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal Language.new(root_dir, info[:language]).name, kata.language.name
  end
  
  test "exercise is set from manifest" do
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)
    assert_equal Exercise.new(root_dir, info[:exercise]).name, kata.exercise.name    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "avatar creation saves manifest.rb and empty increments.rb in avatar dir" do  
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)    
    avatar = Avatar.create(kata, 'wolf')    
    
    assert_equal [
        [ 'manifest.rb', { "name" => "content for name" }.inspect ],
        [ 'increments.rb', [ ].inspect ]
      ],
      @stub_file.write_log[avatar.dir]
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "avatar creation sets up initial git repo of visible files" do  
    info = @stub_file.kata_manifest
    kata = Kata.create(root_dir, info)    
    avatar = Avatar.create(kata, 'wolf')    
    
    assert_equal [
          [ 'init', '--quiet'],
          [ 'add', 'increments.rb' ],
          [ 'add', 'manifest.rb'],
          [ 'add', 'sandbox/name'],
          [ 'commit', "-a -m '0' --quiet" ],
          [ 'commit', "-m '0' 0 HEAD" ]
        ], 
      @stub_git.log[avatar.dir]
      
    assert_equal nil, @stub_file.read_log[avatar.dir]
    
    assert_equal [ [ 'manifest.rb', info.inspect ] ], @stub_file.write_log[kata.dir]         
    assert_equal [ [ 'manifest.rb' ] ], @stub_file.read_log[kata.dir]
  end
    
  
end
