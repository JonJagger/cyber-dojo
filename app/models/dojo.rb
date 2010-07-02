
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

  def money_ladder_update(avatar_name, latest_increment)
    # this method must be atomic (otherwise
    # increments could interleave and be lost) 
    # so I do not use the (get)money_ladder function
    ladder = default_money_ladder
    File.open(folder, 'r') do |f|
      flock(f) do |lock|
        if !File.exists?(money_ladder_filename)
          File.open(money_ladder_filename, 'w') do |file| 
            file.write(ladder.inspect) 
          end          
        else
          ladder = eval IO.read(money_ladder_filename)
        end       
        money_ladder_rung_update(ladder, avatar_name, latest_increment)
        File.open(money_ladder_filename, 'w') do |file|
          file.write(ladder.inspect) 
        end
      end # flock
    end # File.open
    ladder
  end

  def money_ladder
    ladder = default_money_ladder
    File.open(folder, 'r') do |f|
      flock(f) do |lock|
        if File.exists?(money_ladder_filename)
          ladder = eval IO.read(money_ladder_filename)
        end
      end
    end
    ladder
  end

  def bank
    # the following interleaving is possible
    # 1. frogs click "bank"
    # 2. lions click "bank"
    # 3. lions bank is serviced here
    # 4. frogs bank is serviced here
    # This means that at the time the frogs clicked "bank"
    # there was something to bank but by the time the
    # request reaches the server there isn't.
    # However, this is harmless, since the balance is unaltered.
    # But again, this function must be atomic.
    ladder = {}
    File.open(folder, 'r') do |f|
      flock(f) do |lock|
        ladder = eval IO.read(money_ladder_filename)
        ladder[:balance] += ladder[:offer]
        ladder[:offer] = 0
        ladder[:failed_rungs] = []
        ladder[ :error_rungs] = []
        ladder[:passed_rungs] = []
        File.open(money_ladder_filename, 'w') do |file|
          file.write(ladder.inspect) 
        end       
      end # flock
    end # File.open
    ladder
  end

  def folder
    Root_folder + '/' + name
  end

private

  Root_folder = RAILS_ROOT + '/' + 'dojos'

  def money_ladder_filename
    folder + '/' + 'money_ladder.rb'
  end

  def default_money_ladder
    { :balance => 0,
      :offer => 0,
      :failed_rungs => [],
      :error_rungs => [],
      :passed_rungs => []
    }
  end

  def money_ladder_rung_update(ladder, avatar, inc)
    ladder[:failed_rungs].delete_if { |rung| rung[:avatar] == avatar }
    ladder[ :error_rungs].delete_if { |rung| rung[:avatar] == avatar }
    ladder[:passed_rungs].delete_if { |rung| rung[:avatar] == avatar }

    new_rung = { :avatar => avatar, :time => inc[:time] }

    ladder[:failed_rungs] << new_rung if inc[:outcome] == :failed
    ladder[ :error_rungs] << new_rung if inc[:outcome] == :error
    ladder[:passed_rungs] << new_rung if inc[:outcome] == :passed

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

  end

end

#----------------------------------------------

def flock(file)
  success = file.flock(File::LOCK_EX)
  if success
    begin
      yield file
    ensure
      file.flock(File::LOCK_UN)
    end
  end
  return success
end

