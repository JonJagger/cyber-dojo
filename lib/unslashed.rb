
module Unslashed # mix-in

  module_function

  def unslashed(path)
    path.chomp('/')
  end

end
