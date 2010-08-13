
class DojoController < ApplicationController

  def index
    # offers create/enter
  end

  def create
  	@filesets = FileSet.names    	  	
  end
  
  def new
    name = params['name'].to_s
    folder = RAILS_ROOT + '/dojos/' + name
    if name === ""
      flash[:name_notice] = 'Please choose a name'
      redirect_to :action => 'create'    	    	
    elsif File.exists?(folder)
      flash[:name_notice] = 'Sorry, there is already a CyberDojo named ' + name
      redirect_to :action => 'create'    	
    else    	
      Dir.mkdir(folder)
      File.open(folder + '/' + 'manifest.rb', 'w') do |file|
      	manifest = { :filesets => params['filesets'] }
        file.write(manifest.inspect) 
      end   
      redirect_to :action => 'index'
    end
  rescue
    flash[:name_notice] = 'Sorry, illegal name: ' + name
    redirect_to :action => 'new'
  end

   
  
  def enter
    name = params[:name]
    if !File.exists?(RAILS_ROOT + '/dojos/' + name)
      flash[:enter_notice] = 'There is no dojo named: ' + name
      redirect_to :action => 'index'
    else
      redirect_to :controller => 'kata', 
                  :action => 'index',
                  :dojo => name
    end
  end

  def dashboard
    name = params[:name]
    @dojo = Dojo.new(params[:name])
    render :layout => 'dashboard_view'
  end

end
