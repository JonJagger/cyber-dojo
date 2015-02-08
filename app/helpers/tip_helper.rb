
module TipHelper

  def traffic_light_tip(id, avatar, was_tag, now_tag)
    tip = "Click to open #{avatar.name}#{apostrophe}s "
    tip += "#{was_tag} #{arrow} #{now_tag} diff"
    diff = avatar.tags[was_tag.to_i].diff(now_tag.to_i)
    added_count,deleted_count = line_counts(diff)
    tip += "<div>&bull; #{plural(added_count, 'added line')}</div>"
    tip += "<div>&bull; #{plural(deleted_count, 'deleted line')}</div>"
    tip
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
