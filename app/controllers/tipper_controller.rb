
class TipperController < ApplicationController

  include TipHelper
  
  def tip
    id = params['id']
    avatar_name = params['avatar_name']
    wasTag = params['was_tag']
    nowTag = params['now_tag']
    render :json => {
      :html => traffic_light_tip(id,avatar_name,was_tag,now_tag)
    }
  end

end
