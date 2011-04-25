
require 'digest/sha1'
require 'file_write.rb'
require 'io_lock.rb'
require 'make_time.rb'

class Dojo

  Index_filename = 'index.rb' 

  def self.rotation_choices
    [
      { :mins => 5, :label => "5 mins",   :checked => "checked" },
      { :mins => 10, :label => "10 mins", :checked => ""  },
    ]
  end
  
  def self.duration_choices
    [
      { :mins => 20, :label => "20 mins", :checked => "" },
      { :mins => 40, :label => "40 mins", :checked => "" },
      { :mins => 60, :label => "1 hour",  :checked => "checked" },
      { :mins => 120,:label => "2 hours", :checked => "" },
    ]
  end
  
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
    if File.directory? inner and File.directory? outer
      return false
    else
      io_lock(root_folder) do
        make_dir(inner)
        make_dir(outer)
      end
      return true
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
        :minutes_per_rotation => params['rotation'].to_i,
        :minutes_duration => params['duration'].to_i,
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
      
      rotation = {}
      rotation[:already_rotated] = []
      rotation[:prev_rotation_at] = make_time(now)      
      rotation[:next_rotation_at] = make_time(now + info[:minutes_per_rotation] * 60)
      file_write(dojo.rotation_filename, rotation)
      
      file_write(dojo.ladder_filename, [])
    end    
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
    age[:total_mins] >= minutes_duration
  end
  
  def age
    diff = Time.now - created
    diff,secs = diff.divmod(60)
    total_mins = diff
    diff,mins = diff.divmod(60)
    days,hours = diff.divmod(24)    
    { :days => days, :hours => hours, :mins => mins, :secs => secs.to_i, :total_mins => total_mins }
  end

  def avatars
    Avatar.names.select { |name| exists? name }.map { |name| Avatar.new(self, name) } 
  end

  def seconds_per_heartbeat
    5
  end

  def heartbeat(avatar_name)
    if closed
      ""
    elsif rotation(avatar_name)[:do_now]
      "<h2>...ROTATE NOW. ..</h2>" +
      "<h2>Keyboard drivers please take a non-driver role,</h2>" +
      "<h2>either at the same computer or at a new computer.</h2>"
    else
      ""
    end
  end

  def ladder
    rungs = io_lock(folder) { eval IO.read(ladder_filename) }
    rungs.sort! { |lhs,rhs| lhs[:avatar] <=> rhs[:avatar] }
  end

  def ladder_update(avatar_name, latest_increment)
    io_lock(folder) do
      rungs = eval IO.read(ladder_filename)
      rungs.delete_if { |rung| rung[:avatar] == avatar_name } 
      rungs << { :avatar => avatar_name, :time => latest_increment[:time], :outcome => latest_increment[:outcome] }
      file_write(ladder_filename, rungs)
    end
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

  def rotation_filename
    folder + '/' + 'rotation.rb'
  end

  def ladder_filename
    folder + '/' + 'ladder.rb'
  end  

  def created
    Time.mktime(*manifest[:created])
  end
  
  def minutes_per_rotation
    manifest[:minutes_per_rotation]
  end

  def minutes_duration
    manifest[:minutes_duration]
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

  def rotation(avatar_name)
    options = {}
    io_lock(folder) do
      options = eval IO.read(rotation_filename)
      
      now = Time.now      

      already_rotated = options[:already_rotated].include?(avatar_name)
      very_recent_rotation = (now - Time.mktime(*options[:prev_rotation_at])).abs <= seconds_per_heartbeat
      due = Time.mktime(*options[:next_rotation_at])
      
      if now > due
        # first avatar over the now-line
        # but don't rotate if we're re-entering a dojo after a long break
        options[:do_now] = (now - due < (2 * seconds_per_heartbeat))
        options[:prev_rotation_at] = make_time(now)
        due = now + minutes_per_rotation * 60
        options[:next_rotation_at] = make_time(due)
        options[:already_rotated] = [avatar_name]
      elsif !already_rotated && very_recent_rotation
        # another avatar over the line
        # but don't re-rotate for the first avatar again
        options[:do_now] = true
        options[:already_rotated] << avatar_name  
      else
        options[:do_now] = false
      end

      file_write(rotation_filename, options)
    end
    options
  end
  
end


