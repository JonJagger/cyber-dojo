
class DashboardController < ApplicationController

  def show
    @kata = Kata.new(root_dir, id)    
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    @auto_refresh = flag(:auto_refresh, true)
    @title = id[0..5] + ' dashboard'

    # provide these if you want to open the diff-dialog
    # for a specific avatar,was_tag,now_tag as the
    # dashboard opens
    if params['avatar'] && params['was_tag'] && params['now_tag']
      @id = id
      @avatar_name = params['avatar']
      @was_tag = params['was_tag']
      @now_tag = params['now_tag']
      @max_tag = Avatar.new(@kata, @avatar_name).traffic_lights.length
    end
  end

  def heartbeat
    @kata = Kata.new(root_dir, id)    
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    @auto_refresh = flag(:auto_refresh, true)
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def help_dialog
    render :layout => false    
  end
  
  # reinstate if anyone asks for this...
  def download
    # an id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    uuid = Uuid.new(id)
    inner = uuid.inner
    outer = uuid.outer
    cd_cmd = "cd #{root_dir}/katas"
    tar_cmd = "tar -zcf ../zips/#{id}.tar.gz #{inner}/#{outer}"
    system(cd_cmd + ";" + tar_cmd)
    send_file "#{root_dir}/zips/#{id}.tar.gz", :type=>'application/zip'
  end

private

  def seconds_per_column
    positive(:seconds_per_column, 60)
  end
  
  def maximum_columns
    positive(:maximum_columns, 30)
  end
  
  def positive(symbol, default)
    value = params[symbol].to_i
    value > 0 ? value : default    
  end
 
  def flag(symbol, default)
    tf = params[symbol]
    return tf if tf == "true"
    return tf if tf == "false"
    return default
  end
end
