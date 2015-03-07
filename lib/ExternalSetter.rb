
module ExternalSetter # mixin

  def set_external(symbol, object)
    externals[symbol] ||= pathed(symbol,object)
  end

  def reset_external(symbol, object)
    externals[symbol] = pathed(symbol,object)
  end

  def unset_external(symbol)
    externals[symbol] = nil
  end
  
private

  def externals
    $cyber_dojo_externals ||= {}
  end 

  def pathed(symbol,object)
    if symbol.to_s.end_with? '_path'
      object += '/' if !object.end_with? '/'
    end
    object
  end
  
end

# another option here is monkey-patching

# using the current thread doesn't work because when the externals are
# set in config/initializers/externals.rb
# it is often run in a different thread to the thread incoming
# requests are serviced on (eg via Passenger)
