
module TrafficLightHelper

  # The data-id, data-avatar-name, data-was-tag, data-now-tag
  # values are used to create click handlers that open a diff-dialog
  # See setupTrafficLightOpensDiffDialogHandlers()
  # in app/helpers/traffic_light_helper.rb

  def diff_traffic_light(kata, avatar_name, light, max_lights)
    # used from test page and from dashboard page
    number = light['number'].to_i
    "<div class='diff-traffic-light'" +
        " title='#{tool_tip(avatar_name,light)}'" +
        " data-id='#{kata.id}'" +
        " data-avatar-name='#{avatar_name}'" +
        " data-was-tag='#{number-1}'" +
        " data-now-tag='#{number}'" +
        " data-max-tag='#{max_lights}'>" +
        traffic_light_image(colour(light), 17, 54) +
     "</div>"
  end

  def diff_avatar_image(kata, avatar_name, light, max_lights)
    number = light['number']
    "<div class='diff-traffic-light'" +
        " title='Click to review #{avatar_name}#{apostrophe}s code'" +
        " data-id='#{kata.id}'" +
        " data-avatar-name='#{avatar_name}'" +
        " data-was-tag='0'" +
        " data-now-tag='1'" +
        " data-max-tag='#{max_lights}'>" +
        "<img src='/images/avatars/#{avatar_name}.jpg'" +
            " alt='#{avatar_name}'" +
            " width='45'" +
            " height='45'/>" +
     "</div>"
  end

  def traffic_light_image(colour, width, height)
    "<img src='/images/traffic_light_#{colour}.png'" +
       " alt='#{colour} traffic-light'" +
       " width='#{width}'" +
       " height='#{height}'/>"
  end

  def tool_tip(avatar_name, light)
    n = light['number'].to_i
    "Click to review #{avatar_name}#{apostrophe}s #{n-1} #{arrow} #{n} diff"
  end

  def colour(light)
     # very old dojos used 'outcome'
     (light['colour'] || light['outcome']).to_s
  end

  def apostrophe
    '&#39;'
  end

  def arrow
    '&harr;'
  end

end
