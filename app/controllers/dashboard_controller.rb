
class DashboardController < ApplicationController

  def show
    gather
    @title = id[0..5] + ' dashboard'
    # provide these if you want to open the diff-dialog for a
    # specific [avatar,was_tag,now_tag] as the dashboard opens.
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
    gather
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def help_dialog
    render :layout => false    
  end

private

  def gather
    @kata = cd[id]
    @minute_columns = bool('minute_columns')
    @auto_refresh = bool('auto_refresh')
    @seconds_per_column = seconds_per_column    
  end
  
  def bool(attribute)
    tf = params[attribute]
    return tf if tf == "true"
    return tf if tf == "false"
    return "true"
  end

  def seconds_per_column
    flag = params['minute_columns']
    if !flag || flag == "true"
      return 60
    else
      return 60*60*24*365*1000 
    end
  end
 
end
