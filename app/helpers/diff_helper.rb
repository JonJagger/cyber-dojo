
module DiffHelper
  
  def diff_tip(n_deleted, n_added)
    pluralize(n_deleted, "deletion") + " &amp; " + pluralize(n_added, "addition")
  end
  
  def diff_dots(n, kind)
    html = '<table>'
    html += '<tr>'
    html +=   spaced_ellision(n) if kind == 'deleted'    
                [MaxDots,n].min.times { html += td_dot(kind) }    
    html +=   spaced_ellision(n) if kind == 'added'
    html += '</tr>'
    html += '</table>'
  end
    
private
  
  def spaced_ellision(n)
    html = ""
    if n <= MaxDots
      (MaxDots - n).times { html += td_dot('spacer') }
      html += ellision('off')
    else
      html += ellision('on')
    end
    html
  end
  
  def ellision(on_off)
    "<td><span class='diff_dots #{on_off}'></span></td>"
  end
  
  def td_dot(kind)
    "<td><div class='#{kind} dot'></div></td>"
  end

  MaxDots = 3
  
end
