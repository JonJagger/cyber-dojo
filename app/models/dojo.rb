
require 'io_lock.rb'

class Dojo

  def self.names
    Dir.entries(Root_folder).select { |name| name != '.' and name != '..' }
  end

  def initialize(name)
    @name = name
  end

  def name
    @name
  end

  def avatars
    alive = []
    Avatar.names.each do |avatar_name|
      alive << Avatar.new(self, avatar_name) if File.exists?(folder + '/' + avatar_name)
    end
    alive
  end

  def folder
    Root_folder + '/' + name
  end

  def rotation(avatar_name)
  	options = {}
  	io_lock(folder) do
  		if File.exists?(rotation_filename)
  			options = eval IO.read(rotation_filename)
  		end

      mins_per_rotate = 5
      secs_per_rotate = mins_per_rotate * 60
      
      now = Time.now
    	due = now + secs_per_rotate
      options[:already_dinged] ||= []
      options[:prev_ding_at] ||= [1966,11,23,0,0,0]      
      options[:next_ding_at] ||= [due.year, due.month, due.day, due.hour, due.min, due.sec]

      already_dinged = options[:already_dinged].include?(avatar_name)
      refresh_period = 5 # from view_panel.html.erb :frequency
      very_recent_ding = (now - Time.mktime(*options[:prev_ding_at])).abs <= refresh_period
      due = Time.mktime(*options[:next_ding_at])
      
      if now > due
      	# first avatar over the now-line
      	# but don't ding if we're re-entering a dojo after a long break
        options[:ding_now] = (now - due < (2 * refresh_period))
        options[:prev_ding_at] = [now.year, now.month, now.day, now.hour, now.min, now.sec]
        due = now + secs_per_rotate
        options[:next_ding_at] = [due.year, due.month, due.day, due.hour, due.min, due.sec]
        options[:already_dinged] = [avatar_name]
      elsif !already_dinged && very_recent_ding
     		# another avatar over the line
     		# but don't re-ding for the first avatar again
     	  options[:ding_now] = true
     		options[:already_dinged] << avatar_name	
      else
      	options[:ding_now] = false
      end

      File.open(rotation_filename, 'w') do |file|
        file.write(options.inspect) 
      end        		
  	end
  	options
  end
  
  def money_ladder
    ladder = default_money_ladder
    io_lock(folder) do
      if File.exists?(money_ladder_filename)
        ladder = eval IO.read(money_ladder_filename)
      else
        File.open(money_ladder_filename, 'w') do |file|
          file.write(ladder.inspect)
        end
      end      
    end
    ladder
  end

  def money_ladder_update(avatar_name, latest_increment)
    ladder = {}    
    io_lock(folder) do
      ladder = eval IO.read(money_ladder_filename)         
      money_ladder_rung_update(ladder, avatar_name, latest_increment)
      File.open(money_ladder_filename, 'w') do |file|
        file.write(ladder.inspect) 
      end
    end
    ladder
  end
 
private

  def rotation_filename
  	folder + '/' + 'rotation.rb'
  end

  def money_ladder_filename
    folder + '/' + 'money_ladder.rb'
  end  
  
  Root_folder = RAILS_ROOT + '/' + 'dojos'
    
  def default_money_ladder
    { :balance => 0,
      :offer => 0,
      :failed_rungs => [],
      :error_rungs => [],
      :passed_rungs => [],
      :blank_rungs => [],
    }
  end
   
  def money_ladder_rung_update(ladder, avatar, inc)
  	# remove this avatar's entry from the ladder
    ladder[:failed_rungs].delete_if { |rung| rung[:avatar] == avatar }
    ladder[ :error_rungs].delete_if { |rung| rung[:avatar] == avatar }
    ladder[:passed_rungs].delete_if { |rung| rung[:avatar] == avatar }
    ladder[ :blank_rungs].delete_if { |rung| rung[:avatar] == avatar }
    # and add it back into the ladder in it's updated state
    new_rung = { :avatar => avatar, :time => inc[:time] }
    ladder[:failed_rungs] << new_rung if inc[:outcome] == :failed
    ladder[ :error_rungs] << new_rung if inc[:outcome] == :error
    ladder[:passed_rungs] << new_rung if inc[:outcome] == :passed

    ladder[:balance] +=
        (ladder[:error_rungs].size + 8) +
        (ladder[:failed_rungs].size * 8) +
        (ladder[:passed_rungs].size ** 8)
  end
  
end


