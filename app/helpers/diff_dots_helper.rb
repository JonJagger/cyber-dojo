module DiffDotsHelper
  
  def diff_dots(n, kind)
    max_dots = 3
    html = '<table>'
    html += '<tr>'

    if kind == 'deleted'
      if n <= max_dots
        (max_dots - n).times { html += td_dot('spacer') }
        html += '<td><diff_dots class="off"></diff_dots></td>'
      else
        html += '<td><diff_dots class="on"></diff_dots></td>'
      end
    end

    [max_dots,n].min.times { html += td_dot(kind) }

    if kind == 'added'
      if n <= max_dots
        (max_dots - n).times { html += td_dot('spacer') }
        html += '<td><diff_dots class="off"></diff_dots></td>'
      else
        html += '<td><diff_dots class="on"></diff_dots></td>'
      end
    end

    html += '</tr>'
    html += '</table>'
  end

  def td_dot(kind)
    "<td><div class='#{kind} dot'></div></td>"
  end
  
end
