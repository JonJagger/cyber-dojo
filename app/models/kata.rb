
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
  
  #TODO create_new(root_dir, id, info) (info has everything except id)
  def self.create_new(root_dir, info)    
    katas_root_dir = root_dir + '/katas'
    inner_dir = katas_root_dir + '/' + Kata::inner_dir(info[:id])
    
    if !File.directory? inner_dir
      Dir.mkdir inner_dir
    end
    
    outer_dir = inner_dir + '/' + Kata::outer_dir(info[:id])
    Dir.mkdir outer_dir
    Files::file_write(outer_dir + '/manifest.rb', info)
  end
  
  def self.exists?(root_dir, id)
    inner_dir = root_dir + '/katas/' + Kata::inner_dir(id)
    outer_dir = inner_dir + '/' + Kata::outer_dir(id)
    # can I just do outer_dir check here?
    File.directory? inner_dir and File.directory? outer_dir
  end

  Index_filename = 'index.rb' 
  
  #---------------------------------

  def initialize(root_dir, id)
    @root_dir,@id = root_dir,id
  end

  def name
    manifest[:name]
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
  
  def visible_files
    manifest[:visible_files]
  end
  
  def tab
    " " * manifest[:tab_size]
  end
  
  def unit_test_framework
    manifest[:unit_test_framework]
  end
  
  def language    # TODO: forward to Language.new(...) ?
    manifest[:language]
  end
  
  def exercise    # TODO: forward to Exercise.new(...) ?
    manifest[:exercise]    
  end
      
  def created
    Time.mktime(*manifest[:created])
  end
  
  def age_in_seconds
    (Time.now - created).to_i
  end
  
  def dir    
    root_dir + '/katas/' + Kata::inner_dir(id) + '/' + Kata::outer_dir(id)
  end
  
  def id
    @id
  end
  
private

  def root_dir
    @root_dir
  end
  
  def manifest_filename
    dir + '/' + 'manifest.rb'
  end
  
  def manifest
    eval IO.read(manifest_filename)
  end
  
end


