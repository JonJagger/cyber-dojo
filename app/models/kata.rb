
require 'digest/sha1'
require 'make_time_helper.rb'
require 'traffic_light_helper.rb'
require 'Locking'
require 'Files'

class Kata
  
  include Locking
  extend Locking  
  include MakeTimeHelper
  extend MakeTimeHelper
  include TrafficLightHelper
  extend TrafficLightHelper
  include Files
  extend Files
  
  def self.create_new(fileset, params)
    info = { 
      :name => params[:kata_name], 
      :created => make_time(Time.now),
      :exercise => fileset.exercise,
      :language => fileset.language,
      :uuid => `uuidgen`.strip.delete('-')[0..9],      
      :browser => params[:browser],
      
      :visible_files => fileset.visible_files,
      :unit_test_framework => fileset.unit_test_framework,
      :tab_size => fileset.tab_size,
    }
    katas_dir = params[:kata_root]    
    uuid = info[:uuid]
    inner_dir = katas_dir + '/' + uuid[0..1]
    Dir.mkdir inner_dir
    outer_dir = inner_dir + '/' + uuid[2..9]
    Dir.mkdir outer_dir
    file_write(outer_dir + '/messages.rb', [ ])    
    file_write(outer_dir + '/manifest.rb', info)

    sandbox = outer_dir + '/' + 'sandbox'
    Dir.mkdir sandbox    
    fileset.copy_hidden_files_to(sandbox)

    [:visible_files, :unit_test_framework, :tab_size].each do |cut|
      info.delete(cut)  
    end
    
    info
  end
  
  
  
  
  Index_filename = 'index.rb' 

  def self.exists?(params)
    name = params[:kata_name]
    root_dir = params[:kata_root]    
    inner_dir = root_dir + '/' + Kata::inner_dir(name)
    outer_dir = inner_dir + '/' + Kata::outer_dir(name)
    File.directory? inner_dir and File.directory? outer_dir
  end

  def self.create(params)
    name = params[:kata_name]
    katas_dir = params[:kata_root]    
    inner_dir = katas_dir + '/' +Kata::inner_dir(name)
    outer_dir = inner_dir + '/' + Kata::outer_dir(name)
    
    # TODO: this could move outside...?
    if !File.directory? katas_dir
      make_dir(katas_dir)
    end

    io_lock(katas_dir) do
      if File.directory? inner_dir and File.directory? outer_dir
        false
      else
        # TODO: I could pre-mkdir all the inner folders 00 01 02 ff ??
        #       git init; does not do this...
        # Two players could make the same dir concurrently.
        # Does that need to be locked?
        make_dir(inner_dir)
        make_dir(outer_dir)
        true
      end
    end
  end
  
  def self.configure(params)
    
    fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
          
    info = { 
      :name => params[:kata_name], 
      :created => make_time(Time.now),
      :exercise => fileset.exercise,
      :language => fileset.language,
      :uuid => `uuidgen`.strip.delete('-')[0..9],      
      :browser => params[:browser],
      
      :visible_files => fileset.visible_files,
      :unit_test_framework => fileset.unit_test_framework,
      :tab_size => fileset.tab_size,
    }
    
    
    katas_dir = params[:kata_root]
    io_lock(katas_dir) do
      kata = Kata.new(params)
      
      sandbox_dir = kata.dir + '/sandbox' 
      make_dir(sandbox_dir)
      
      fileset.copy_hidden_files_to(sandbox_dir)
      
      file_write(kata.dir + '/manifest.rb', info)
      file_write(kata.dir + '/messages.rb', [ ])
      
      #TODO: this should move outside?
      #      yes, make this return info
      index_filename = katas_dir + '/' + Kata::Index_filename
      index = File.exists?(index_filename) ? eval(IO.read(index_filename)) : [ ]
      
      [:visible_files, :unit_test_framework, :tab_size].each do |cut|
        info.delete(cut)  
      end
      
      file_write(index_filename, index << info)      
    end    
  end

  def self.inner_dir(name)
    Kata::sha1(name)[0..1] # ala git    
  end

  def self.outer_dir(name)
    Kata::sha1(name)[2..-1] # ala git
  end

  def self.sha1(name)
    Digest::SHA1.hexdigest(name)
  end
  
  #---------------------------------

  def initialize(params)
    @name = params[:kata_name]
    @katas_dir = params[:kata_root]
  end

  def name
    @name
  end
    
  def avatar_names
    Avatar.names.select { |name| exists? name }
  end
  
  def avatars
    avatar_names.map { |name| Avatar.new(self, name) }
  end

  def all_increments
    avatars.inject({}) do |result,avatar|
      result.merge( { avatar.name => avatar.increments } )
    end
  end
  
  def seconds_per_heartbeat
    10
  end

  def messages
    io_lock(messages_filename) { eval IO.read(messages_filename) }
  end

  def post_message(sender_name, text, type = :notification)
    messages = [ ]
    io_lock(messages_filename) do
      messages = eval IO.read(messages_filename)
      text = text.strip
      if text != ''
        messages <<  { 
          :sender => sender_name, 
          :text => text,
          :created => make_time(Time.now),
          :type => type
        }
        file_write(messages_filename, messages)
      end
    end
    messages
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
    duration_in_seconds(created, Time.now)
  end
  
  def dir
    @katas_dir + '/' + Kata::inner_dir(name) + '/' + Kata::outer_dir(name)
  end
  
private

  def manifest_filename
    dir + '/' + 'manifest.rb'
  end

  def messages_filename
    dir + '/' + 'messages.rb'
  end
  
  def manifest
    eval IO.read(manifest_filename)
  end

  def exists?(name)
    File.exists? dir + '/' + name
  end
  
  def self.make_dir(name)
    if !File.directory? name
      Dir.mkdir name
    end
  end
  
end


