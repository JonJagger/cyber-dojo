
module ManifestProperty # mixin

  def manifest_property
    property_name = (caller[0] =~ /`([^']*)'/ and $1)
    manifest[property_name]
  end

end
