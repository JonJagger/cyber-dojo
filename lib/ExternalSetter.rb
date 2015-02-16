
module ExternalSetter # mixin

  def set_external(symbol, object)
    Thread.current[symbol] ||= pathed(symbol,object)
  end

  def reset_external(symbol, object)
    Thread.current[symbol] = pathed(symbol,object)
  end

private

  def pathed(symbol,object)
    if [:exercises_path,:languages_path,:katas_path].include?(symbol) && !object.nil?
      object += '/' if !object.end_with?('/')      
    end
    object
  end
  
end

# another option here is monkey-patching
