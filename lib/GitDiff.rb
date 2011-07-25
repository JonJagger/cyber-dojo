require 'GitDiffBuilder'
require 'GitDiffParser'
require 'Files'

module GitDiff

  include Files
  include Ids
  
  def git_diff_view(avatar, tag)
      
      cmd  = "cd #{avatar.folder};"
      cmd += "git show #{tag}:manifest.rb;"
      manifest = eval popen_read(cmd)
      visible_files = manifest[:visible_files]
      
      cmd  = "cd #{avatar.folder};"
      cmd += "git diff --ignore-space-at-eol --find-copies-harder #{tag-1} #{tag} sandbox;"   
      diff_lines = popen_read(cmd)
  
      view = {}
      builder = GitDiffBuilder.new()
      
      diffs = GitDiffParser.new(diff_lines).parse_all
           
      diffs.each do |sandbox_name,diff|
        
        md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
        if md[1] == 'b'
          name = md[2]
          # md[1] == 'a' indicates a deleted file
          # which of course is not in the manifest for this tag
          if name == 'output'
            undiff(diff)
          end
          file = visible_files[name]
          if file
            view[name] = builder.build(diff, line_split(file[:content]))
            visible_files.delete(name)
          end
        end
      end
      
      visible_files.each do |name,file|
        view[name] = sameify(file[:content])
      end
      
      view
  end

  #-----------------------------------------------------------
  
  def undiff(diff)
    diff[:chunks].each do |chunk|
      chunk[:sections].each do |section|
        section[:after_lines] = section[:added_lines]
        section.delete(:deleted_lines)
        section.delete(:added_lines)
      end
    end
  end

  #-----------------------------------------------------------
  
  def git_diff_prepare(diffed_files)
    diffs = []
    generate = IdGenerator.new("jj")
    diffed_files.sort.each do |name,diff|
      id = generate.id      
      diffs << {
        :deleted_line_count => diff.count { |line| line[:type] == :deleted },
        :id => id,          
        :name => name,
        :added_line_count => diff.count { |line| line[:type] == :added },
        :content => git_diff_html(diff),
      }
    end
    diffs    
  end

  #-----------------------------------------------------------
  
  def most_changed_lines_file_id(diffs)
    
    output = diffs.find {|diff| diff[:name] == 'output'}
    # early dojos will have diffs that don't include output
    # because they were created before output became a 
    # pseudo filename
    id = (output != nil) ? output[:id] : diffs[0][:id]
    id_changed_line_count = 0
    
    diffs.each do |diff|
      changed_line_count = diff[:deleted_line_count] + diff[:added_line_count]
      if changed_line_count > id_changed_line_count
        id_changed_line_count = changed_line_count
        id = diff[:id]
      end
    end
    id
  end
  
  #-----------------------------------------------------------
  
  def git_diff_html(diff)
    max_digits = diff.length.to_s.length
    lines = diff.map {|n| diff_htmlify(n, max_digits) }.join("\n")
  end
  
  #-----------------------------------------------------------
  
  def diff_htmlify(n, max_digits)
      "<#{n[:type]}>" +
         '<ln>' + spaced_line_number(n[:number], max_digits) + '</ln>' +
         CGI.escapeHTML(n[:line]) + 
      "</#{n[:type]}>"
  end
  
    #-----------------------------------------------------------
    
  def spaced_line_number(n, max_digits)
      digit_count = n.to_s.length
      ' ' * (max_digits - digit_count) + n.to_s 
  end
  
end
