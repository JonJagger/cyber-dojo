
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
  	# with a poll-based rotation it is tricky to ensure
  	# 1) each laptop dings 
  	# 2) the first one to ding does not ding twice in a row
  	# 3) a laptop joining half way through a rotation does not ding 
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
      due = Time.mktime(*options[:next_ding_at])

      already_dinged = options[:already_dinged].include?(avatar_name)
      very_recent_ding = now - Time.mktime(*options[:prev_ding_at]) <= 6
      
      diff = now - due
      if diff >= 0
      	# first avatar one over the line
      	# TODO: could be entering a dojo which hasn't been entered in a long time
      	#       in which case you'll get an immeadiate rotation... not right...worth fixing?
        options[:ding_now] = true
        options[:prev_ding_at] = [now.year, now.month, now.day, now.hour, now.min, now.sec]
        due = now + secs_per_rotate
        options[:next_ding_at] = [due.year, due.month, due.day, due.hour, due.min, due.sec]
        options[:already_dinged] = [avatar_name]
      elsif !already_dinged && very_recent_ding
     		# another avatar over the line	
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
      monetize(ladder)
      File.open(money_ladder_filename, 'w') do |file|
        file.write(ladder.inspect) 
      end
    end
    ladder
  end
 
  def bank
    ladder = {}
    io_lock(folder) do
      ladder = eval IO.read(money_ladder_filename)
      ladder[:balance] += ladder[:offer]
      ladder[:offer] = 0     
      ladder[:blank_rungs] = ladder[:blank_rungs] + ladder[:passed_rungs]
      ladder[:passed_rungs] = []
      monetize(ladder)
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
  
  def leading_zero(number)
  	if number < 10
  		"0" + number.to_s
  	else
  		number
  	end
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
  end
  
  def monetize(ladder)
    amount = 100
    multiplier = 1

    amount, multiplier = re_rung(ladder[:passed_rungs], amount, multiplier)

    if ladder[:passed_rungs].size > 0
      ladder[:offer] = amount
    else
      ladder[:offer] = 0
    end

    amount, multiplier = re_rung(ladder[:error_rungs], amount, multiplier)
    amount, multiplier = re_rung(ladder[:failed_rungs], amount, multiplier)
    amount, multiplier = re_rung(ladder[:blank_rungs], amount, multiplier)    
  end

  def re_rung(rungs, amount, multiplier)
    rungs.shuffle!
    rungs.reverse.each do |rung|
      amount *= multiplier
      multiplier += 1
      rung[:amount] = amount
    end  
    [amount, multiplier]
  end
  
end


