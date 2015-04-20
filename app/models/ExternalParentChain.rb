
module ExternalParentChain # mixin

  def dir
    disk[path]
  end

  def method_missing(command,*args)   
    args.unshift(path) if command == :git && args[0].class == Symbol      
    return @parent.send(command,*args) 
  end

end

#- - - - - - - - - - - - - - - - - - - - - - - - - - -
# All the model classes include this module.
# It assumes each class has path and @parent.
# Its effect is to pass calls (to externals) up
# the child->parent chain all the way to the root
# Dojo object where the externals are held.
# It inserts the calling object's path into args
# being careful to do this only once if there are
# several parent connections. 
# See also app/models/Dojo.rb
#- - - - - - - - - - - - - - - - - - - - - - - - - - -
