require 'shellwords'

def build_images(path)
  Dir.glob(path) do |file|
    Dir.chdir(File.dirname(file))
    exec = File.basename(file)

#    p File.dirname(file)
#    `./#{exec}`

    print "cd " + Shellwords.shellescape(File.dirname(file)) + "\n"
    print "./" + Shellwords.shellescape(exec) + "\n"
  end
end

