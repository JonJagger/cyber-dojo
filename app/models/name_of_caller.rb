
module NameOfCaller # mix-in

  module_function

  def name_of(caller)
    # eg caller[0] == "dojo.rb:7:in `exercises'"
    /`(?<name>[^']*)/ =~ caller[0] && name
  end

end
