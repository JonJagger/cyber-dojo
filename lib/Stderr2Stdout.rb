
module Stderr2Stdout # mix-in

  module_function

  def stderr2stdout(cmd)
    cmd + ' ' + '2>&1'
  end

end
