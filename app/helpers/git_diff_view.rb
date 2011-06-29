
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
        # I could handle this though, by retrieving it explicitly...but I don't
        if name == 'output'
          undiff(diff)
        end
        file = visible_files[name]
        if file
          view[name] = builder.build(diff, line_split(file[:content]))
          visible_files.delete(name)
        else
          # I don't think this should ever happen...
        end
      end
    end
    
    visible_files.each do |name,file|
      view[name] = sameify(file[:content])
    end
    
    view
end

def undiff(diff)
  diff[:chunks].each do |chunk|
    chunk[:sections].each do |section|
      section[:after_lines] = section[:added_lines]
      section.delete(:deleted_lines)
      section.delete(:added_lines)
    end
  end
end

