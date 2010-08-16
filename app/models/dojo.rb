
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

  def manifest_filename
    folder + '/' + 'manifest.rb'
  end
  
  def manifest
  	if File.exists? manifest_filename
      eval IO.read(manifest_filename)
    else
    	{ :filesets => {} }
    end
  end
  
  def rotation_filename
  	folder + '/' + 'rotation.rb'
  end

  def rotation
  	options = { 'bell' => 'yes' }
  	io_lock(folder) do
  		if File.exists?(rotation_filename)
  			options = eval IO.read(rotation_filename)
  		end

      mins_per_rotate = 5
      secs_per_rotate = mins_per_rotate * 60
      
      now = Time.now
      if !options[:due_at]
      	due = now + secs_per_rotate
        options[:due_at] = [due.year, due.month, due.day, due.hour, due.min, due.sec]
      end

      diff = now - Time.mktime(*options[:due_at])
      if diff >= 0
        options[:now] = true
        due = Time.mktime(*options[:due_at]) + secs_per_rotate
        options[:due_at] = [due.year, due.month, due.day, due.hour, due.min, due.sec]
      else
      	options[:now] = false
      	diff = diff.abs
      	options[:due_mins] = (diff / 60).to_int
      	options[:due_secs] = leading_zero((diff % 60).to_int)
      end
  		
      File.open(rotation_filename, 'w') do |file|
        file.write(options.inspect) 
      end        		
  	end
  	options
  end
  
  def money_ladder_filename
    folder + '/' + 'money_ladder.rb'
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

    ladder[:passed_rungs].shuffle!
    ladder[:passed_rungs].reverse.each do |rung|
      amount *= multiplier
      multiplier += 1
      rung[:amount] = amount
    end    

    if ladder[:passed_rungs].size > 0
      ladder[:offer] = amount
    else
      ladder[:offer] = 0
    end

    ladder[:error_rungs].shuffle!
    ladder[:error_rungs].reverse.each do |rung|
      amount *= multiplier
      multiplier += 1
      rung[:amount] = amount
    end    
    
    ladder[:failed_rungs].shuffle!
    ladder[:failed_rungs].reverse.each do |rung|
      amount *= multiplier
      multiplier += 1
      rung[:amount] = amount
    end    
    
    ladder[:blank_rungs].shuffle!
    ladder[:blank_rungs].reverse.each do |rung|
      amount *= multiplier
      multiplier += 1
      rung[:amount] = amount
    end    
  end

end


