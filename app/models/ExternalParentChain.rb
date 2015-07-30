
module ExternalParentChain # mixin

  def dir
    disk[path]
  end

  def method_missing(command,*args)   
    return @parent.send(command,*args) 
  end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
# All the model classes include this module.
# method_missing assumes the including class has two things
#   @parent
#   disk 
#   path (a string)
# Its effect is to pass calls (to externals) up
# the child->parent chain all the way to the root
# Dojo object where the externals are held.
# See also app/models/Dojo.rb
#- - - - - - - - - - - - - - - - - - - - - - - - - - -
