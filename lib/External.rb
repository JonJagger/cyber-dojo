
module External # mixin

  def external(symbol)
    raise RuntimeError.new("external(:#{symbol})") if $cyber_dojo_externals.nil?
    raise RuntimeError.new("external(:#{symbol}]") if $cyber_dojo_externals[symbol].nil?
    $cyber_dojo_externals[symbol]
  end

end
