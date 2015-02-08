
module TipHelper

  def traffic_light_tip_html(avatar, was_tag, now_tag)
    was_tag = was_tag.to_i
    now_tag = now_tag.to_i
    lights = avatar.lights
    tip = 'Click to review '
    tip += "#{avatar.name}'s"   # panda's
    tip += ' '
    tip += colour_tag(lights, was_tag)      # 13
    tip += ' '
    tip += "#{arrow}"                       # <->
    tip += ' '
    tip += colour_tag(lights, now_tag)      # 14
    tip += ' '
    tip += 'diff'
    diff = avatar.tags[was_tag].diff(now_tag)
    added_count,deleted_count = line_counts(diff)
    tip += "<div>&bull; #{plural(added_count, 'added line')}</div>"
    tip += "<div>&bull; #{plural(deleted_count, 'deleted line')}</div>"
    tip
  end

  def traffic_light_count_tip_html(avatar_name, bulb_count, colour)
    avatar_name + ' has ' +
    plural(bulb_count, 'traffic-light') +
    ' and is at ' +
    "<span class='#{colour}'>" + colour + '</span>.'
  end

  def colour_tag(lights,tag)
    colour = lights[tag-1].colour
    "<span class='#{colour}'>#{tag}</span>"
  end

  def apostrophe
    '&#39;'
  end

  def arrow
    '&harr;'
  end

  def line_counts(diffed_files)
    added_count,deleted_count = 0,0
    diffed_files.each do |filename,diff|
      if filename != 'output'
        added_count   += diff.count { |line| line[:type] == :added   }
        deleted_count += diff.count { |line| line[:type] == :deleted }
      end
    end
    [added_count,deleted_count]
  end

  def plural(count, text)
    count.to_s + ' ' + text + (count == 1 ? '' : 's')
  end

end
