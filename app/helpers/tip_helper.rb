
require_relative './../lib/git_diff'

module TipHelper # mix-in

  include GitDiff

  def traffic_light_tip_html(avatar, was_tag, now_tag)
    was_tag = was_tag.to_i
    now_tag = now_tag.to_i
    lights = avatar.lights
    tip = 'Click to review '
    tip += "#{avatar.name}'s"                  # panda's
    tip += '<br/>'
    tip += light_colour_tag(lights, was_tag)   # 13
    tip += ' '
    tip += "#{arrow}"                          # <->
    tip += ' '
    tip += light_colour_tag(lights, now_tag)   # 14
    tip += ' '
    tip += 'diff'
    diff = avatar_git_diff(avatar, was_tag, now_tag)
    added_count, deleted_count = line_counts(diff)
    tip += "<div>#{plural(added_count, 'added line')}</div>"
    tip += "<div>#{plural(deleted_count, 'deleted line')}</div>"
    tip
  end

  def light_colour_tag(lights, tag)
    colour = (tag == 0) ? 'none' : lights[tag-1].colour
    colour_tag(colour, tag)
  end

  def colour_tag(colour, tag)
    "<span class='#{colour}'>#{tag}</span>"
  end

  def plural(count, text)
    count.to_s + ' ' + plural_word(text, count)
  end

  def plural_word(word, count)
    word = 'timeout' if word == 'timed_out'
    word + (count == 1 ? '' : 's')
  end

  def arrow
    '&harr;'
  end

  def line_counts(diffed_files)
    added_count = 0
    deleted_count = 0
    diffed_files.each do |filename, diff|
      if filename != 'output'
        added_count   += diff.count { |line| line[:type] == :added   }
        deleted_count += diff.count { |line| line[:type] == :deleted }
      end
    end
    [added_count, deleted_count]
  end

end
