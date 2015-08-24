
module IdSplitter # mix-in

  def outer(id)
    id[0..1]  # 'E5'
  end

  def inner(id)
    id[2..-1] # '6A3327FE'
  end
  
end
