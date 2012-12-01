require 'GitDiffBuilder'
require 'GitDiffParser'
require 'LineSplitter'
require 'Uuid'

module GitDiff

  include LineSplitter
  
  # Top level functions used by diff_controller.rb to create data structure
  # (to build view from) containing diffs for all files, for a given avatar, 
  # for a given tag.
  
  def git_diff_view(avatar, from_tag, to_tag, visible_files = nil)
      visible_files ||= avatar.visible_files(to_tag)      
      diff_lines = avatar.diff_lines(from_tag, to_tag)      
      view = { }      
      diffs = GitDiffParser.new(diff_lines).parse_all           
      diffs.each do |sandbox_name,diff|        
        md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
        if md
          filename = md[2]
          if deleted_file?(md[1])
            file_content = diff[:chunks][0][:sections][0][:deleted_lines]
            view[filename] = deleteify(file_content)            
          else
            file_content = visible_files[filename]
            view[filename] = GitDiffBuilder.new().build(diff, line_split(file_content))
          end
          visible_files.delete(filename)
        end
      end

      # other files have not changed...      
      visible_files.each do |filename,content|
        view[filename] = sameify(content)
      end
      
      view
  end

  #-----------------------------------------------------------  
  
  def git_diff_prepare(avatar, tag, diffed_files)
    diffs = [ ]
    diffed_files.sort.each do |name,diff|
      id = 'id_' + Uuid.new.to_s
      diffs << {
        :id => id,
        :name => name,
        :section_count => diff.count { |line| line[:type] == :section },
        :deleted_line_count => diff.count { |line| line[:type] == :deleted },
        :added_line_count => diff.count { |line| line[:type] == :added },
        :content => git_diff_html(id,diff),
      }
    end
    diffs    
  end

  #-----------------------------------------------------------
  
  def deleted_file?(ch)
    # GitDiffParser uses names beginning with
    # a/... to indicate a deleted file 
    # b/... to indicate a new/modified file
    # This mirrors the git diff command output
    ch == 'a'
  end
  
  #-----------------------------------------------------------
  
  def most_changed_lines_file_id(diffs)        
    most_changed_diff = diffs[0]
    diffs.each do |diff|
      if most_changed_diff[:name] == 'output' && change_count(diff) > 0
          most_changed_diff = diff
      elsif diff[:name] != 'output' && change_count(diff) > change_count(most_changed_diff)
        most_changed_diff = diff
      end
    end
    most_changed_diff[:id]
  end
  
  #-----------------------------------------------------------
  
  def change_count(diff)
    diff[:deleted_line_count] + diff[:added_line_count]
  end
  
  #-----------------------------------------------------------
  
  def git_diff_html(id,diff)
    max_digits = diff.length.to_s.length
    lines = diff.map {|n| diff_htmlify(id, n, max_digits) }.join("")
  end
  
  #-----------------------------------------------------------
  
  def diff_htmlify(id, n, max_digits)
    result = ""
    if n[:type] == :section
      result = "<span id='id_#{id}_section_#{n[:index]}'></span>"
    else
      result = "<#{n[:type]}>" +
        '<ln>' + spaced_line_number(n[:number], max_digits) + '</ln>' +
        CGI.escapeHTML(n[:line]) + 
        "</#{n[:type]}>"
    end
    result
  end
  
  #-----------------------------------------------------------
    
  def spaced_line_number(n, max_digits)
    max_digits = [max_digits,3].max
    n = n.to_s
    ' ' * (max_digits - n.length) + n
  end

  #-----------------------------------------------------------

  def sameify(source)
    ify(line_split(source), :same)
  end

  #-----------------------------------------------------------

  def deleteify(lines)
    ify(lines, :deleted)
  end

  #-----------------------------------------------------------

  def ify(lines,type)
    result = [ ]
    lines.each_with_index do |line,number|
      result << {
        :line => line,
        :type => type,
        :number => number + 1
      }
    end
    result
  end

end
