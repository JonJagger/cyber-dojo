
def build_images(path)
  Dir.glob(path) do |file|
    p File.dirname(file)
    Dir.chdir(File.dirname(file))
    exec = File.basename(file)
#    p exec
    `./#{exec}`
  end
end

