require 'open4'

# Using Open4
#https://github.com/ahoward/open4

class BackgroundProcess
  def start(cmd)
    Open4::popen4(cmd)
  end
end
