
module ExternalSetter # mixin

  def set_external(symbol, object)
    thread[symbol] ||= pathed(symbol,object)
  end

  def reset_external(symbol, object)
    thread[symbol] = pathed(symbol,object)
  end

  def unset_external(symbol)
    thread[symbol] = nil
  end
  
private

  def thread
    Thread.current
  end

  def pathed(symbol,object)
    if symbol.to_s.end_with?('_path')
      object += '/' if !object.end_with?('/')      
    end
    object
  end
  
end

# another option here is monkey-patching
