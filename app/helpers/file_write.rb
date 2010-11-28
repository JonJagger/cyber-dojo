
def file_write(path, object)
  # When doing a git diff on a repository that includes files created
  # by this function I found the output contained extra lines thus
  # \ No newline at end of file
  # So I've appended a newline to help keep git quieter.
  File.open(path, 'w') { |file| file.write object.inspect + "\n" }
end
