require File.dirname(__FILE__) + '/stub_disk_file'
require File.dirname(__FILE__) + '/stub_disk_git'

class KataTests < ActionController::TestCase

  def setup
    @stub_file = StubDiskFile.new
    @stub_git = StubDiskGit.new
    Thread.current[:file] = @stub_file
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
  
  test "id is from ctor" do
    # recreation of existing kata from get request uses incoming
    # id as key. So id has to be ctor argument even though
    # id is stored in manifest saved in Kata.create
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)
    assert_equal id, kata.id    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not end in slash" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)        
    assert !kata.dir.end_with?(@stub_file.separator),
          "!#{kata.dir}.end_with?(#{@stub_file.separator})"       
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir does not have doubled separator" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)        
    doubled_separator = @stub_file.separator * 2
    assert_equal 0, kata.dir.scan(doubled_separator).length    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "dir is based on root_dir and id" do
    id = '45ED23A2F1'
    kata = Kata.new(root_dir, id)        
    assert kata.dir.match(root_dir), "root_dir"
    uuid = Uuid.new(id)
    assert kata.dir.match(uuid.inner), "id.inner"
    assert kata.dir.match(uuid.outer), "id.outer"
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "creation saves manifest in kata dir" do
    id = '45ED23A2F1'
    manifest = { :id => id }    
    kata = Kata.create(root_dir, manifest)
    assert_equal [ [ 'manifest.rb', manifest.inspect ] ], @stub_file.write_log[kata.dir]    
    assert_equal nil, @stub_file.read_log[kata.dir]
  end
    
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    
  test "created date property is set from manifest" do
    now = [2013,6,29,14,24,51]
    id = '45ED23A2F1'    
    manifest = { :created => now, :id => id }
    
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    kata = Kata.create(root_dir, manifest)
    assert_equal Time.mktime(*now), kata.created    
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "age_in_seconds is set from manifest" do
    now = [2013,6,29,14,24,51]
    id = '45ED23A2F1'    
    manifest = { :created => now, :id => id }
    
    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    kata = Kata.create(root_dir, manifest)
    seconds = 5
    now = now[0...-1] + [now.last + seconds ]
    assert_equal seconds, kata.age_in_seconds(Time.mktime(*now))    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "language is set from manifest" do
    language = 'Wibble'
    id = '45ED23A2F1'    
    manifest = { :language => language, :id => id }
    
    dir = Kata.new(root_dir, id).dir    
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    kata = Kata.create(root_dir, manifest)
    assert_equal language, kata.language.name
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "exercise is set from manifest" do
    exercise = 'Tweedle'
    id = '45ED23A2F1'    
    manifest = { :exercise => exercise, :id => id }
    
    dir = Kata.new(root_dir, id).dir    
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    kata = Kata.create(root_dir, manifest)
    assert_equal exercise, kata.exercise.name    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "kata visible_files is set from manifest" do
    id = '45ED23A2F1'
    visible_files = {
        'name' => 'content for name'      
    }
    manifest = {
      :id => id,
      :visible_files => visible_files
    }
    dir = Kata.new(root_dir, id).dir    
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  
    kata = Kata.create(root_dir, manifest)
    assert_equal visible_files, kata.visible_files
  end  
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "Kata.exists? returns false before kata is created then true after kata is created" do
    id = '45ED23A2F1'   
    assert !Kata.exists?(root_dir, id), "Kata.exists? false before created"
    manifest = { :id => id }
    Kata.create(root_dir, manifest)
    assert Kata.exists?(root_dir, id), "Kata.exists? true after created"
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "Kata.find returns nil before kata is created then object after kata is created" do
    id = '45ED23A2F1'
    kata = Kata.find(root_dir, id)
    assert_nil kata, "Kata.find returns nil before created"
    manifest = { :id => id }
    Kata.create(root_dir, manifest)
    kata = Kata.find(root_dir, id)
    assert_not_nil kata, "Kata.find returns kata before created"    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  test "you can create an avatar in a kata" do
    id = '45ED23A2F1'   
    manifest = { :id => id }
    kata = Kata.create(root_dir, manifest)
    avatar_name = 'hippo'
    avatar = Avatar.new(kata, avatar_name)
    assert avatar_name, avatar.name
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "multiple avatars in a kata are all seen" do
    id = '45ED23A2F1'   
    manifest = {
      :id => id,
      :visible_files => {
        'name' => 'content for name'
      }      
    }

    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  

    kata = Kata.create(root_dir, manifest)
    Avatar.create(kata, 'lion')
    Avatar.create(kata, 'hippo')
    avatars = kata.avatars
    assert_equal 2, avatars.length
    assert_equal ['hippo','lion'], avatars.collect{|avatar| avatar.name}.sort
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "start_avatar succeeds once for each avatar name then fails" do
    id = '45ED23A2F1'   
    manifest = {
      :id => id,
      :visible_files => {
        'name' => 'content for name'
      }      
    }

    dir = Kata.new(root_dir, id).dir
    @stub_file.read = {
      :dir => dir,
      :filename => 'manifest.rb',
      :content => manifest.inspect
    }  

    kata = Kata.create(root_dir, manifest)

    created = [ ]
    Avatar.names.length.times do |n|
      avatar = kata.start_avatar
      assert_not_nil avatar
      created << avatar
    end
    assert_equal Avatar.names.length, created.collect{|avatar| avatar.name}.uniq.length  
      
    avatar = kata.start_avatar
    assert_nil avatar
  end

end
