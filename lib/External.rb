
module External # mixin

  def external(symbol)
    thread = Thread.current
    raise RuntimeError.new('no external(:' + symbol.to_s + ')') if thread[symbol].nil?
    thread[symbol]
  end

end
