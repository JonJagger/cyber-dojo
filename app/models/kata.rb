
require 'Files'
require 'make_time_helper.rb'

class Kata
  
  include MakeTimeHelper
  extend MakeTimeHelper
  
  def self.inner_dir(id)
    id[0..1] || ""
  end
  
  def self.outer_dir(id)
    id[2..9] || ""
  end
  
  def self.create_new(root_dir, info)
    # I'm running out of inode space on cyber-dojo.com
    # df -i
    # Filesystem    Inodes   IUsed     IFree  IUse%  Mounted on
    # /dev/sda1     655360  561569     93791    86%  /
    # /dev/sda2   19546112      67  19546045     1%  /mnt
    #
    # ...so my plan is to migrate katas to a ln'd folder in /mnt
    # ...after a week or so (while all new entries will have gone
    #... into katas2 )clean out katas folder
    # ruby prune_small true 5 7
    # ruby zipup.rb 5 7
    # ruby prune_large true 5 7
    # ...katas/ should now be empty
    # rmdir katas
    # ln -s katas /mnt/katas
    # chown -R www-data katas
    # chgrp -R www-daya katas
    # ...now both katas and katas2 link to /mnt/katas
    # ...now remove katas2 from code and tests
    # git pull
    # service apache2 restart
    # ...now everything goes to katas again which ln's to /mnt/katas
    # ...so finally remove the katas2 ln which doesn't need to point
    # ...to /mnt/katas any more
    # rm katas2
    
    katas_root_dir = root_dir + '/katas2'    
    if !File.directory? katas_root_dir
      Dir.mkdir katas_root_dir
    end
    
    inner_dir = katas_root_dir + '/' + Kata::inner_dir(info[:id])    
    if !File.directory? inner_dir
      Dir.mkdir inner_dir
    end
    
    outer_dir = inner_dir + '/' + Kata::outer_dir(info[:id])
    # info[:id] is a UUid.gen so outer_dir will be unique inside inner_dir
    Dir.mkdir outer_dir
    Files::file_write(outer_dir + '/manifest.rb', info)
  end
  
  def self.exists?(root_dir, id)
    File.directory? Kata.new(root_dir,id).dir
  end

  #---------------------------------

  def initialize(root_dir, id)
    @root_dir,@id = root_dir,id
    if File.directory? pathed_dir('katas2')
      @katas_folder = 'katas2'
    else
      @katas_folder = 'katas'
    end
  end

  def name
    manifest[:name]
  end
  
  def diff
    if manifest[:diff_id]
      Diff.new(manifest)
    else
      nil
    end
  end
  
  def avatar_names
    Avatar.names.select { |name| File.exists? dir + '/' + name }
  end
  
  def avatars
    avatar_names.map { |name| Avatar.new(self, name) }
  end

  def all_increments
    all = { }
    avatars.each do |avatar|
      all[avatar.name] = avatar.increments
    end
    all
  end
  
  def language
    Language.new(@root_dir, manifest[:language])
  end
  
  def exercise
    Exercise.new(@root_dir, manifest[:exercise])
  end

  def visible_files
    # language.visible_files != visible_files
    # this is because kata.visible_files has the
    # instructions file and output 'pseudo' file
    # mixed in
    manifest[:visible_files]
  end
      
  def created
    Time.mktime(*manifest[:created])
  end
  
  def age_in_seconds( now = Time.now )
    (now - created).to_i
  end
  
  def dir    
    pathed_dir @katas_folder
  end
  
  def id
    @id
  end
  
private

  def root_dir
    @root_dir
  end
  
  def pathed_dir(katas_folder_name)
    root_dir + '/' + katas_folder_name +
      '/' + Kata::inner_dir(id) + '/' + Kata::outer_dir(id)    
  end

  def manifest_filename
    dir + '/' + 'manifest.rb'
  end
  
  def manifest
    eval IO.read(manifest_filename)
  end
  
end

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

class Diff
  
  def initialize(manifest)
    @manifest = manifest
  end
  
  def id
    @manifest[:diff_id]
  end
  
  def avatar
    @manifest[:diff_avatar]
  end
  
  def tag
    @manifest[:diff_tag]
  end
  
end
