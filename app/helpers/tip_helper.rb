
module TipHelper

  def traffic_light_tip(avatar, was_tag, now_tag)
    lights = avatar.lights
    tip = 'Click to review '
    tip += "#{avatar.name}#{apostrophe}s"   # panda's
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
