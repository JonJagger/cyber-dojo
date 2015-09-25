
module TipHelper

  def traffic_light_tip_html(avatar, was_tag, now_tag)
    was_tag = was_tag.to_i
    now_tag = now_tag.to_i
    lights = avatar.lights
    tip = 'Click to review '
    tip += "#{avatar.name}'s"                  # panda's
    tip += ' '
    tip += light_colour_tag(lights, was_tag)   # 13
    tip += ' '
    tip += "#{arrow}"                          # <->
    tip += ' '
    tip += light_colour_tag(lights, now_tag)   # 14
    tip += ' '
    tip += 'diff'
    diff = avatar.diff(was_tag,now_tag)
    added_count,deleted_count = line_counts(diff)
    tip += "<div>&bull; #{plural(added_count, 'added line')}</div>"
    tip += "<div>&bull; #{plural(deleted_count, 'deleted line')}</div>"
    tip
  end

  def traffic_light_count_tip_html(params)
        avatar_name = params['avatar']
             colour = params['current_colour']
          red_count = params['red_count'      ].to_i
        amber_count = params['amber_count'    ].to_i
        green_count = params['green_count'    ].to_i
    timed_out_count = params['timed_out_count'].to_i
    bulb_count = red_count + amber_count + green_count + timed_out_count

    html = avatar_name + ' has ' + 
      plural(bulb_count, 'traffic-light') + '<br/>' +
      plural_colour(  red_count, 'red'  ) +
      plural_colour(amber_count, 'amber') +
      plural_colour(green_count, 'green')
    html += plural_colour(timed_out_count, 'timed_out') if timed_out_count != 0
    html
  end

  def light_colour_tag(lights,tag)
    colour = (tag == 0) ? 'none' : lights[tag-1].colour
    colour_tag(colour, tag)
  end

  def plural_colour(count,colour)
    word = plural_word(colour,count)
    "<div>" +
      "&bull; #{count} #{colour_tag(colour,word)}" +
    "</div>"
  end

  def plural(count, text)
    count.to_s + ' ' + plural_word(text,count)
  end

  def plural_word(word,count)
    word = 'timeout' if word == 'timed_out'
    word + (count == 1 ? '' : 's')
  end

  def colour_tag(colour,tag)
    "<span class='#{colour}'>#{tag}</span>"
  end

  def arrow
    '&harr;'
  end

  def line_counts(diffed_files)
    added_count,deleted_count = 0,0
    diffed_files.each do |filename, diff|
      if filename != 'output'
        added_count   += diff.count { |line| line[:type] == :added   }
        deleted_count += diff.count { |line| line[:type] == :deleted }
      end
    end
    [added_count, deleted_count]
  end

end
