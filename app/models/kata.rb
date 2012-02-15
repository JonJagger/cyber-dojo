
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
  
  def self.inner_dir(uuid)
    uuid[0..1]
  end
  
  def self.outer_dir(uuid)
    uuid[2..9]
  end
  
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
    inner_dir = katas_dir + '/' + Kata::inner_dir(uuid)
    
    if !File.directory? inner_dir
      Dir.mkdir inner_dir
    end
    
    outer_dir = inner_dir + '/' + Kata::outer_dir(uuid)
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
  
  #TODO: only needed temporarily...drop when each button embeds its own kata.id
  def self.exists?(params)
    name = params[:kata_name]
    root_dir = params[:kata_root]    
    inner_dir = root_dir + '/' + Kata::inner_dir(name)
    outer_dir = inner_dir + '/' + Kata::outer_dir(name)
    File.directory? inner_dir and File.directory? outer_dir
  end

  Index_filename = 'index.rb' 
  
  #---------------------------------

  def initialize(params)
    @id = params[:kata_name]
    @katas_dir = params[:kata_root]
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
    @katas_dir + '/' + Kata::inner_dir(id) + '/' + Kata::outer_dir(id)
  end
  
  def id
    @id
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
  
end


