
module TipHelper

  def traffic_light_tip(id,avatarName,wasTag,nowTag)
    "Click to review #{avatarName}#{apostrophe}s #{wasTag} #{arrow} #{nowTag} diff"
  end

  def apostrophe
    '&#39;'
  end

  def arrow
    '&harr;'
  end

end
