
def git_diff_view(avatar, tag)
    
    cmd  = "cd #{avatar.folder};"
    cmd += "git show #{tag}:manifest.rb;"
    manifest = eval IO::popen(cmd).read
    visible_files = manifest[:visible_files]
    
    cmd  = "cd #{avatar.folder};"
    # TODO: add --find-copies-harder
    cmd += "git diff --ignore-space-at-eol #{tag-1} #{tag} sandbox;"   
    diff_lines = IO::popen(cmd).read

    view = {}
    builder = GitDiffBuilder.new()
    
    diffs = GitDiffParser.new(diff_lines).parse_all
    diffs.each do |sandbox_name,diff|
      
      md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
      if md[1] == 'b'
        name = md[2]
        # md[1] == 'a' indicates a deleted file
        # which of course is not in the manifest for this tag
        # I could handle this though, by retrieving it explicitly...
        source_lines = visible_files[name][:content]
        view[name] = builder.build(diff, source_lines.split("\n"))
        visible_files.delete(name)
      end
    end
    
    visible_files.each do |name,file|
      view[name] = sameify(file[:content])
    end
    
    view
end

