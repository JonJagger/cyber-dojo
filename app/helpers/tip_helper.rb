
module TipHelper

  def traffic_light_tip_html(avatar, was_tag, now_tag)
    was_tag = was_tag.to_i
    now_tag = now_tag.to_i
    lights = avatar.lights
    tip = 'Click to review '
    tip += "#{avatar.name}'s"   # panda's
    tip += ' '
    tip += light_colour_tag(lights, was_tag)      # 13
    tip += ' '
    tip += "#{arrow}"                       # <->
    tip += ' '
    tip += light_colour_tag(lights, now_tag)      # 14
    tip += ' '
    tip += 'diff'
    diff = avatar.tags[was_tag].diff(now_tag)
    added_count,deleted_count = line_counts(diff)
    tip += "<div>&bull; #{plural(added_count, 'added line')}</div>"
    tip += "<div>&bull; #{plural(deleted_count, 'deleted line')}</div>"
    tip
  end

  def traffic_light_count_tip_html(params)
    avatar_name = params['avatar']
    bulb_count = params['bulb_count'].to_i
    colour = params['current_colour']
    red_count = params['red_count'].to_i
    amber_count = params['amber_count'].to_i
    green_count = params['green_count'].to_i
    timed_out_count = params['timed_out_count'].to_i
    avatar_name + ' has ' + plural(bulb_count, 'traffic-light') + '<br/>' +
    plural_colour_tag(red_count, 'red') +
    plural_colour_tag(amber_count, 'amber') +
    plural_colour_tag(green_count, 'green') +
    plural_colour_tag(timed_out_count, 'timed_out')
  end

  def light_colour_tag(lights,tag)
    colour_tag(lights[tag-1].colour, tag)
  end

  def plural_colour_tag(count,colour)
    word = plural_word(colour,count)
    "<div>" +
      "&bull; #{count} #{colour_tag(colour,word)}" +
    "</div>"
  end

  def plural_word(word,count)
    word = 'timeout' if word === 'timed_out'
    word + (count === 1 ? '' : 's')
  end

  def colour_tag(colour,tag)
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
