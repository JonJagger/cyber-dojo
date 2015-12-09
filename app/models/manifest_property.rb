
module ManifestProperty # mix-in

  module_function

  def manifest_property
    property_name = name_of(caller)
    manifest[property_name]
  end

  include NameOfCaller

end
