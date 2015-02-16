
module External # mixin

  def external(symbol)
    object = Thread.current[symbol]
    raise RuntimeError.new('no external(:' + symbol.to_s + ')') if object.nil?
    object
  end

end
