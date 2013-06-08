
class DashboardController < ApplicationController

  def show
    @kata = Kata.new(root_dir, id)    
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    @title = id[0..4] + ' dashboard'    
  end

  def heartbeat
    @kata = Kata.new(root_dir, id)    
    @seconds_per_column = seconds_per_column
    @maximum_columns = maximum_columns
    respond_to do |format|
      format.js if request.xhr?
    end
  end
  
  def seconds_per_column
    positive(:seconds_per_column, 30)
  end
  
  def maximum_columns
    positive(:maximum_columns, 30)
  end

  def positive(symbol, default)
    value = params[symbol].to_i
    value > 0 ? value : default    
  end
  
  def tips_dialog
    render :layout => false        
  end
  
  def download
    # an id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    # however, I flatten out this inner/outer folder structure
    # so the resulting archive is 01FE818E86.tar.gz
    uuid = Uuid.new(id)
    inner = uuid.inner
    outer = uuid.outer
    cd_cmd = "cd #{root_dir}/katas/#{inner}"
    zip_cmd = "find #{outer} -print | xargs tar -s /#{outer}/#{inner}#{outer}/ -czf ../../zips/#{id}.tar.gz"
    system(cd_cmd + ";" + zip_cmd)
    send_file "#{root_dir}/zips/#{id}.tar.gz", :type=>'application/zip'
  end
  
end
