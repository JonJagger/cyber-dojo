
class TipperController < ApplicationController

  include TipHelper

  def traffic_light_tip
    render :json => {
      :html => traffic_light_tip_html(avatar,was_tag,now_tag)
    }
  end

  def traffic_light_count_tip
    bulb_count = params['bulb_count']
    current_colour = params['current_colour']
    render :json => {
      :html =>
        traffic_light_count_tip_html(avatar_name,bulb_count,current_colour)
    }
  end

end
