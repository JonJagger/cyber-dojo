
module Slashed # mix-in

  module_function

  def slashed(path)
    path + (path.end_with?('/') ? '' : '/')
  end

end
