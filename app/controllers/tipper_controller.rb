
class TipperController < ApplicationController

  include TipHelper

  def tip
    id = params['id']
    avatar_name = params['avatar_name']
    was_tag = params['was_tag'].to_i
    now_tag = params['now_tag'].to_i
    render :json => {
      :html => traffic_light_tip(id,avatar,was_tag,now_tag)
    }
  end

end
