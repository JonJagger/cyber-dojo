
module TrafficLightHelper

  # The data-id, data-avatar-name, data-was-tag, data-now-tag
  # values are used to create click handlers that open a diff-dialog
  # See setupTrafficLightOpensDiffDialogHandlers()
  #     setupTrafficLightToolTips()
  # in app/asserts/javascripts/cyber-dojo_traffic_lights.js

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
        "<img src='/images/avatars/#{avatar.name}.jpg'" +
            " alt='#{avatar.name}'" +
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

  def apostrophe
    '&#39;'
  end

end
