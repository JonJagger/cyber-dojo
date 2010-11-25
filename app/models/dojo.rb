
require 'digest/sha1'
require 'file_write.rb'
require 'folders_in.rb'
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
        Dir.mkdir inner
        Dir.mkdir outer
        index = eval IO.read(Index_filename)
        info = { :name => name, :created => make_time(Time.now) }
        index << info        
        file_write(Index_filename, index)
        dojo = Dojo.new(name)
        file_write(dojo.ladder_filename, [])
        file_write(dojo.rotation_filename, {})
        file_write(dojo.manifest_filename, info)
        result = true;
      end
    end
    result
  end

  #---------------------------------
  
  def self.Xnames
    folders_in(folder)
  end

  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def created
    manifest = eval IO.read(manifest_filename)
    Time.mktime(*manifest[:created])
  end

  def avatars
    Avatar.names.select { |name| exists? name }.map { |name| Avatar.new(self, name) } 
  end

  def folder
    id = Digest::SHA1.hexdigest name
    Root_folder + '/' + id[0..1] + '/' + id[2..-1]
  end

  def rotation(avatar_name)
    options = {}
    io_lock(folder) do
      options = eval IO.read(rotation_filename)
      
      mins_per_rotate = 5
      secs_per_rotate = mins_per_rotate * 60
      
      now = Time.now      
      options[:already_rotated] ||= []
      options[:prev_rotation_at] ||= [1966,11,23,0,0,0]      
      options[:next_rotation_at] ||= make_time(due = now + secs_per_rotate)

      already_rotated = options[:already_rotated].include?(avatar_name)
      refresh_period = 5 # from view_panel.html.erb :frequency
      very_recent_rotation = (now - Time.mktime(*options[:prev_rotation_at])).abs <= refresh_period
      due = Time.mktime(*options[:next_rotation_at])
      
      if now > due
        # first avatar over the now-line
        # but don't rotate if we're re-entering a dojo after a long break
        options[:do_now] = (now - due < (2 * refresh_period))
        options[:prev_rotation_at] = make_time(now)
        due = now + secs_per_rotate
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
  
end


