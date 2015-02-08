
class TipperController < ApplicationController

  include TipHelper

  def traffic_light_tip
    render :json => {
      :html => traffic_light_tip_html(avatar,was_tag,now_tag)
    }
  end

  def traffic_light_count_tip
    render :json => {
      :html =>
        traffic_light_count_tip_html(
          avatar_name,
          params['bulb_count'],
          params['current_colour']
        )
    }
  end

  def pie_chart_tip
    render :json => {
      :html =>
        pie_chart_tip_html(
          params['red'],
          params['amber'],
          params['green'],
          params['timed_out']
        )
    }
  end

end
