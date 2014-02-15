
class DashboardController < ApplicationController

  def show
    @kata = Kata.new(root_dir, id)    
    @minute_columns = bool('minute_columns')
    @auto_refresh = bool('auto_refresh')
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    @title = id[0..5] + ' dashboard'

    # provide these if you want to open the diff-dialog for a
    # specific [avatar,was_tag,now_tag] as the dashboard open.
    # See also app/controllers/diff_controller.rb
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
    @minute_columns = bool('minute_columns')
    @auto_refresh = bool('auto_refresh')
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def help_dialog
    render :layout => false    
  end
  
  # left because will be used to xfer dojos to readonly 2nd server
  # reinstate if anyone asks for this?
  def download
    # an id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    uuid = Uuid.new(id)
    inner = uuid.inner
    outer = uuid.outer
    cd_cmd = "cd #{root_dir}/katas"
    tar_cmd = "tar -zcf ../zips/#{id}.tar.gz #{inner}/#{outer}"
    system(cd_cmd + ";" + tar_cmd)
    zip_filename = "#{root_dir}/zips/#{id}.tar.gz"
    send_file zip_filename
    # would like to delete this zip file
    # but download tests unzip them to verify
    # unzipped zip is identical to original 
    #rm_cmd = "rm #{zip_filename}"
    #system(rm_cmd)
  end

private

  def seconds_per_column
    flag = params['minute_columns']
    if  !flag || flag == "true"
      return 60
    else
      return 60*60*24*365*1000 
    end
  end
    
  def maximum_columns
    10000000    
  end
 
  def bool(attribute)
    tf = params[attribute]
    return tf if tf == "true"
    return tf if tf == "false"
    return "true"
  end
end
