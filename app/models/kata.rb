
require 'make_time_helper.rb'
require 'Files'

class Kata
  
  include MakeTimeHelper
  extend MakeTimeHelper
  
  def self.inner_dir(id)
    id[0..1] || ""
  end
  
  def self.outer_dir(id)
    id[2..9] || ""
  end
  
  def self.create_new(fileset)
    info = { 
      :name => fileset.name,
      :created => make_time(Time.now),
      :exercise => fileset.exercise,
      :language => fileset.language,
      :id => `uuidgen`.strip.delete('-')[0..9],      
      :browser => fileset.browser,      
      :visible_files => fileset.visible_files,
      :unit_test_framework => fileset.unit_test_framework,
      :tab_size => fileset.tab_size,
    }
    
    katas_root_dir = fileset.katas_root_dir
    id = info[:id]
    inner_dir = katas_root_dir + '/' + Kata::inner_dir(id)
    
    if !File.directory? inner_dir
      Dir.mkdir inner_dir
    end
    
    outer_dir = inner_dir + '/' + Kata::outer_dir(id)
    Dir.mkdir outer_dir
    Files::file_write(outer_dir + '/manifest.rb', info)

    [:visible_files, :unit_test_framework, :tab_size].each do |cut|
      info.delete(cut)  
    end
    
    info
  end
  
  def self.exists?(params)
    id = params[:id]
    inner_dir = params[:katas_root_dir] + '/' + Kata::inner_dir(id)
    outer_dir = inner_dir + '/' + Kata::outer_dir(id)
    File.directory? inner_dir and File.directory? outer_dir
  end

  Index_filename = 'index.rb' 
  
  #---------------------------------

  def initialize(params)
    @params = params
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
  
  def language
    manifest[:language]
  end
  
  def exercise
    manifest[:exercise]    
  end
      
  def created
    Time.mktime(*manifest[:created])
  end
  
  def age_in_seconds
    (Time.now - created).to_i
  end
  
  def dir    
    @params[:katas_root_dir] + '/' + Kata::inner_dir(id) + '/' + Kata::outer_dir(id)
  end
  
  def id
    @params[:id]
  end
  
private

  def manifest_filename
    dir + '/' + 'manifest.rb'
  end
  
  def manifest
    eval IO.read(manifest_filename)
  end
  
end


