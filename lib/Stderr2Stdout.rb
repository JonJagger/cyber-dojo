
module Stderr2Stdout # mixin

  def stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

end
