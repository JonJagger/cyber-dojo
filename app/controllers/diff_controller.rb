
class DiffController < ApplicationController

  def show
    # diff/show used to be a stand-alone page but
    # it now redirects to the dashboard which auto-opens
    # a diff-dialog
    redirect_to :controller => 'dashboard',
                :action => 'show',
                :id => id,
                :avatar_name => params['avatar'],
                :was_tag => params['was_tag'],
                :now_tag => params['now_tag']
  end
  
end


