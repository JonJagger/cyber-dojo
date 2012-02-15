
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
  
  Index_filename = 'index.rb' 

  def self.exists?(params)
    name = params[:kata_name]
    root_folder = params[:kata_root]    
    inner = root_folder + '/' + Kata::inner_folder(name)
    outer = inner + '/' + Kata::outer_folder(name)
    File.directory? inner and File.directory? outer
  end

  def self.create(params)
    name = params[:kata_name]
    root_folder = params[:kata_root]    
    inner = root_folder + '/' +Kata::inner_folder(name)
    outer = inner + '/' + Kata::outer_folder(name)
    
    # TODO: this could move outside...?
    if !File.directory? root_folder
      make_dir(root_folder)
    end

    io_lock(root_folder) do
      if File.directory? inner and File.directory? outer
        false
      else
        # TODO: I could pre-mkdir all the inner folders 00 01 02 ff ??
        #       git init; does not do this...
        # Two players could make the same dir concurrently.
        # Does that need to be locked?
        make_dir(inner)
        make_dir(outer)
        true
      end
    end
  end
  
  def self.configure(params)
    name = params[:kata_name]
    root_folder = params[:kata_root]
    io_lock(root_folder) do
      kata = Kata.new(params)
      
      sandbox = kata.folder + '/sandbox' 
      make_dir(sandbox)
      
      fileset = InitialFileSet.new(params[:filesets_root], params['language'], params['exercise'])
      fileset.copy_hidden_files_to(sandbox)
            
      info = { 
        :name => name, 
        :created => make_time(Time.now),
        :exercise => fileset.exercise,
        :language => fileset.language,
        :browser => params[:browser],
        :visible_files => fileset.visible_files,
        :unit_test_framework => fileset.unit_test_framework,
        :tab_size => fileset.tab_size,
        #:uuid?
      }
      
      file_write(kata.manifest_filename, info)
      file_write(kata.messages_filename, [ ])
      
      #TODO: this should move outside?
      index_filename = root_folder + '/' + Kata::Index_filename
      index = File.exists?(index_filename) ? eval(IO.read(index_filename)) : [ ]
      #TODO: don't want visible_files in main index. Will get too large...
      file_write(index_filename, index << info)      
    end    
  end

  def self.inner_folder(name)
    Kata::sha1(name)[0..1] # ala git    
  end

  def self.outer_folder(name)
    Kata::sha1(name)[2..-1] # ala git
  end

  def self.sha1(name)
    Digest::SHA1.hexdigest(name)
  end
  
  #---------------------------------

  def initialize(params)
    @name = params[:kata_name]
    @kata_root = params[:kata_root]
    @filesets_root = params[:filesets_root]
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
  
  #TODO: rename to dir?  to match Dir::mkdir for example?
  def folder
    @kata_root + '/' + Kata::inner_folder(name) + '/' + Kata::outer_folder(name)
  end

  #TODO: does this need to be here? public? why not static?
  def filesets_root
    @filesets_root
  end
  
  def manifest_filename
    folder + '/' + 'manifest.rb'
  end

  def messages_filename
    folder + '/' + 'messages.rb'
  end
  
private

  def manifest
    eval IO.read(manifest_filename)
  end

  def exists?(name)
    File.exists? folder + '/' + name
  end
  
  def self.make_dir(name)
    if !File.directory? name
      Dir.mkdir name
    end
  end
  
end


