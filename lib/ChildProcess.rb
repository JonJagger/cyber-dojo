
class ChildProcess

  def self.exec(&block)
    pid = Process.fork
    if pid.nil? # child
      block.call
      exit
    else # parent
      Process.detach(pid)
    end
  end

end
