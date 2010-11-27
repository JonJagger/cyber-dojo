
def file_write(path, object)
  File.open(path, 'w') { |file| file.write object.inspect + "\n" }
end
