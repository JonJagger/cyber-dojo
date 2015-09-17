
module IdSplitter # mix-in

  module_function

  def outer(id)
    id.upcase[0..1]  # 'E5'
  end

  def inner(id)
    id.upcase[2..-1] # '6A3327FE'
  end

end
