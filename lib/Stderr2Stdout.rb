
module Stderr2Stdout # mixin

  module_function

  def stderr2stdout(cmd)
    cmd + ' ' + '2>&1'
  end

end
