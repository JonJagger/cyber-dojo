
module TrafficLightHelper

  # The data-id, data-avatar-name, data-was-tag, data-now-tag
  # properties are used to create click handlers that open a diff-dialog
  #   see setupTrafficLightOpensHistoryDialogHandlers()
  #   in app/asserts/javascripts/cyber-dojo_traffic_lights.js
  # The data-tip property is used to create a hover-tip.
  #   see setupHoverTips()
  #   in app/asserts/javascripts/cyber-dojo_hover_tips.js

  def diff_traffic_light(light)
    # used from test page and from dashboard page
    number = light.number
    avatar = light.avatar
    "<div class='diff-traffic-light'" +
        " data-tip='ajax:traffic_light'" +
        " data-id='#{avatar.kata.id}'" +
        " data-avatar-name='#{avatar.name}'" +
        " data-was-tag='#{number-1}'" +
        " data-now-tag='#{number}'>" +
        traffic_light_image(light.colour, 17, 54) +
     "</div>"
  end

  def diff_avatar_image(avatar)
    "<div class='diff-traffic-light avatar-image'" +
        " data-tip='Click to review #{avatar.name}#{apostrophe}s current code'" +
        " data-id='#{avatar.kata.id}'" +
        " data-avatar-name='#{avatar.name}'" +
        " data-was-tag='-1'" +
        " data-now-tag='-1'>" +
        avatar_image(avatar.name) +
     "</div>"
  end

  def avatar_image(avatar_name)
    size = 45
    "<img src='/images/avatars/#{avatar_name}.jpg'" +
        " alt='#{avatar_name}'" +
        " width='#{size}'" +
        " height='#{size}'/>"
  end

  def traffic_light_image(colour, width, height)
    "<img src='/images/traffic_light_#{colour}.png'" +
       " alt='#{colour} traffic-light'" +
       " width='#{width}'" +
       " height='#{height}'/>"
  end

  def apostrophe
    '&#39;'
  end

end
