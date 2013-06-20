
# silence warning
#    Rack::File headers parameter replaces cache_control after Rack 1.5.
# as per https://gist.github.com/olly/4747477

class Rack::File
  def warn(*)
  end
end
