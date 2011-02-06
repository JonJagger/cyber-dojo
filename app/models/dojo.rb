
require 'digest/sha1'
require 'file_write.rb'
require 'io_lock.rb'
require 'make_time.rb'

class Dojo

  def self.find(name)
    id = Digest::SHA1.hexdigest name
    inner = Root_folder + '/' + id[0..1]
    outer = inner + '/' + id[2..-1]
    File.directory? inner and File.directory? outer
  end
  
  def self.create(name)
    id = Digest::SHA1.hexdigest name
    result = nil
    io_lock(Root_folder) do
      inner = Root_folder + '/' + id[0..1]
      outer = inner + '/' + id[2..-1]
      if File.directory? inner and File.directory? outer
        result = false
      else
        make_dir(inner)
        make_dir(outer)

        now = Time.now
        info = { :name => name, :created => make_time(now) }

        index = []
        if File.exists? Index_filename
          index = eval IO.read(Index_filename)
        end
        index << info        
        file_write(Index_filename, index)
        
        rotation = {}
        rotation[:already_rotated] = []
        rotation[:prev_rotation_at] = make_time(now)      
        rotation[:next_rotation_at] = make_time(now + Seconds_per_rotate)

        dojo = Dojo.new(name)        
        file_write(dojo.ladder_filename, [])
        file_write(dojo.rotation_filename, rotation)
        file_write(dojo.manifest_filename, info)

        result = true;
      end
    end
    result
  end

  #---------------------------------
  
  def initialize(name, readonly = false)
    @name = name
    @readonly = readonly
  end

  def name
    @name
  end

  def created
    manifest = eval IO.read(manifest_filename)
    Time.mktime(*manifest[:created])
  end
  
  def readonly
    expired or @readonly
  end
  
  def expired
    age[:days] > 0 or age[:hours] >= 1
  end
  
  def age
    diff = Time.now - created
    diff,secs = diff.divmod(60)
    diff,mins = diff.divmod(60)
    days,hours = diff.divmod(24)    
    { :days => days, :hours => hours, :mins => mins, :secs => secs.to_i }
  end

  def avatars
    Avatar.names.select { |name| exists? name }.map { |name| Avatar.new(self, name) } 
  end

  def rotation(avatar_name)
    options = {}
    io_lock(folder) do
      options = eval IO.read(rotation_filename)
      
      now = Time.now      

      already_rotated = options[:already_rotated].include?(avatar_name)
      refresh_period = 5 # from _view_panel.html.erb :frequency
      very_recent_rotation = (now - Time.mktime(*options[:prev_rotation_at])).abs <= refresh_period
      due = Time.mktime(*options[:next_rotation_at])
      
      if now > due
        # first avatar over the now-line
        # but don't rotate if we're re-entering a dojo after a long break
        options[:do_now] = (now - due < (2 * refresh_period))
        options[:prev_rotation_at] = make_time(now)
        due = now + Seconds_per_rotate
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
  
  def ladder
    rungs = io_lock(folder) { eval IO.read(ladder_filename) }
    ladder_sort(rungs)
  end

  def ladder_update(avatar_name, latest_increment)
    rungs = []
    io_lock(folder) do
      rungs = eval IO.read(ladder_filename)
      ladder_rung_update(rungs, avatar_name, latest_increment)
      file_write(ladder_filename, rungs)
    end
    ladder_sort(rungs)
  end

  def folder
    id = Digest::SHA1.hexdigest name
    Root_folder + '/' + id[0..1] + '/' + id[2..-1]
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

private

  Seconds_per_rotate = 5 * 60
  
  Root_folder = RAILS_ROOT + '/' + 'dojos'

  Index_filename = Root_folder + '/' + 'index.rb' 

  def exists?(name)
    File.exists? folder + '/' + name
  end
  
  def ladder_rung_update(rungs, avatar, inc)
    rungs.delete_if { |rung| rung[:avatar] == avatar } 
    rungs << { :avatar => avatar, :time => inc[:time], :outcome => inc[:outcome] }
  end
  
  def ladder_sort(rungs)
    rungs.sort! { |lhs,rhs| lhs[:avatar] <=> rhs[:avatar] }
  end

  def self.make_dir(name)
    if !File.directory? name
      Dir.mkdir name
    end
  end
    
end


