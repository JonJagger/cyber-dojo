
def git_diff_view(avatar, tag)
    
    cmd  = "cd #{avatar.folder};"
    cmd += "git show #{tag}:manifest.rb;"
    manifest = eval IO::popen(cmd).read
    visible_files = manifest[:visible_files]
    
    cmd  = "cd #{avatar.folder};"
    cmd += "git diff --ignore-space-at-eol #{tag-1} #{tag} sandbox;"   
    diff_lines = IO::popen(cmd).read

    view = {}
    builder = GitDiffBuilder.new()
    
    diffs = GitDiffParser.new(diff_lines).parse_all
    diffs.each do |sandbox_name,diff|
      name = %r|^sandbox/(.*)|.match(sandbox_name)[1] 
      source_lines = visible_files[name][:content]
      view[name] = builder.build(diff, source_lines.split("\n"))
      visible_files.delete(name)
    end
    
    visible_files.each do |name,file|
      view[name] = sameify(file[:content])
    end
    
    view
end

