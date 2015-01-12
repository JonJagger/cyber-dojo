
module ExternalsSetter # mixin

  def set_external(symbol, object)
    Thread.current[symbol] ||= object
  end

  def reset_external(symbol, object)
    Thread.current[symbol] = object
  end

end

# another option here is monkey-patching
