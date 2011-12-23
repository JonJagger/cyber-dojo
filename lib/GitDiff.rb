require 'GitDiffBuilder'
require 'GitDiffParser'
require 'Files'

module GitDiff

  include Files
  include Ids
  
  # Top level function used by diff_controller.rb to create data structure
  # (to build view from) containing diffs for all files, for a given avatar, 
  # for a given tag.
  # See, test/functional/git_diff_view_tests.rb
  
  def git_diff_view(avatar, tag, manifest = nil)
      builder = GitDiffBuilder.new()

      manifest ||= avatar.manifest(tag)      
      visible_files = manifest[:visible_files]

      cmd  = "cd #{avatar.folder};"
      cmd += "git diff --ignore-space-at-eol --find-copies-harder #{tag-1} #{tag} sandbox;"   
      diff_lines = popen_read(cmd)
  
      view = {}      
      diffs = GitDiffParser.new(diff_lines).parse_all           
      diffs.each do |sandbox_name,diff|        
        md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
        if !deleted_file?(md[1])
          name = md[2]
          file = visible_files[name]
          view[name] = builder.build(diff, line_split(file[:content]))
          visible_files.delete(name)
        end
      end

      # other files have not changed...      
      visible_files.each do |name,file|
        view[name] = sameify(file[:content])
      end
      
      view
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
  
  def git_diff_prepare(diffed_files)
    diffs = [ ]
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
    max_digits = [max_digits,3].max
    n = n.to_s
    n = '-' if n == '' 
    digit_count = n.length
    ' ' * (max_digits - digit_count) + n
  end
  
end
