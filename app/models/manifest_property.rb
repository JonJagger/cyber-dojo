
module ManifestProperty # mix-in

  module_function

  def manifest_property
    property_name = (caller[0] =~ /`([^']*)'/ && $1)
    manifest[property_name]
  end

end
