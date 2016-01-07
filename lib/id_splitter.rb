
module IdSplitter # mix-in

  module_function

  def XX_outer(id)
    id.upcase[0..1]  # 'E5'
  end

  def XX_inner(id)
    id.upcase[2..-1] # '6A3327FE'
  end

end
