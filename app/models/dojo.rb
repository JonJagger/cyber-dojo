
require 'digest/sha1'
require 'file_write.rb'
require 'io_lock.rb'
require 'make_time.rb'

class Dojo

  Index_filename = 'index.rb' 

  def self.find(params)
    name = params[:dojo_name]
    root_folder = params[:dojo_root]    
    inner = root_folder + '/' + Dojo::inner_folder(name)
    outer = inner + '/' + Dojo::outer_folder(name)
    File.directory? inner and File.directory? outer
  end
  
  def self.create(params)
    name = params[:dojo_name]
    root_folder = params[:dojo_root]    
    inner = root_folder + '/' + Dojo::inner_folder(name)
    outer = inner + '/' + Dojo::outer_folder(name)
    
    io_lock(root_folder) do
      if File.directory? inner and File.directory? outer
        false
      else
        make_dir(inner)
        make_dir(outer)
        true
      end
    end
  end
  
  def self.configure(params)
    name = params[:dojo_name]
    root_folder = params[:dojo_root]
    io_lock(root_folder) do
      dojo = Dojo.new(params)
      
      now = Time.now
      info = { 
        :name => name, 
        :created => make_time(now),
      }
      
      info[:katas] = []
      params['kata'].each do |number,kata|
        info[:katas] << kata
      end
      info[:languages] = []
      params['language'].each do |number,language|
        info[:languages] << language
      end
      file_write(dojo.manifest_filename, info)
      
      index = []
      index_filename = root_folder + '/' + Dojo::Index_filename
      if File.exists? index_filename
        index = eval IO.read(index_filename)
      end
      index << info        
      file_write(index_filename, index)

      file_write(dojo.messages_filename, Dojo::initial_message)
    end    
  end

  def self.initial_message
    [
      { :sender => 'compass',
        :text => "Welcome. In a CyberDojo you do deliberate software practice. " +
          "Don't think about releasing, or shipping; think about practising, and improving."  
      },
    ]
  end
  
  def self.inner_folder(name)
    Dojo::sha1(name)[0..1] # ala git    
  end

  def self.outer_folder(name)
    Dojo::sha1(name)[2..-1] # ala git
  end

  def self.sha1(name)
    Digest::SHA1.hexdigest(name)
  end
  
  #---------------------------------

  def initialize(params)
    @name = params[:dojo_name]
    @readonly = params.has_key?(:readonly) ? params[:readonly] : false
    @dojo_root = params[:dojo_root]
    @filesets_root = params[:filesets_root]
  end

  def name
    @name
  end

  def readonly
    closed or @readonly
  end
  
  def closed
    false
  end
  
  def avatars
    Avatar.names.select { |name| exists? name }.map { |name| Avatar.new(self, name) }
  end

  def all_increments
    all = {}
    avatars.each { |avatar| all[avatar.name] = avatar.increments }
    all.sort
  end
  
  def seconds_per_heartbeat
    10
  end

  def messages
    file = messages_filename
    io_lock(file) { eval IO.read(file) }
  end

  def post_message(sender, text)
    messages = []
    file = messages_filename
    io_lock(file) do
      messages = eval IO.read(file)
      text = text.lstrip.rstrip
      if text != ''
        messages <<  { :sender => sender, :text => text }
        file_write(file, messages)
      end
    end
    messages
  end
  
  def filesets_root
    @filesets_root
  end
  
  def dojo_root
    @dojo_root
  end

  def folder
    dojo_root + '/' + Dojo::inner_folder(name) + '/' + Dojo::outer_folder(name)
  end

  def manifest_filename
    folder + '/' + 'manifest.rb'
  end

  def messages_filename
    folder + '/' + 'messages.rb'
  end
  
  def created
    Time.mktime(*manifest[:created])
  end
  
  def manifest
    eval IO.read(manifest_filename)
  end

private

  def exists?(name)
    File.exists? folder + '/' + name
  end
  
  def self.make_dir(name)
    if !File.directory? name
      Dir.mkdir name
    end
  end
  
end


