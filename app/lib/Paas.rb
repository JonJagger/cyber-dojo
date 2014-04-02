
# Paas abstract base class

class Paas

  def path(obj)
    case obj
      when Languages
        root(obj.dojo) + 'languages/'
      when Language
        path(obj.dojo.languages) + obj.name + '/'
      when Exercises
        root(obj.dojo) + 'exercises/'
      when Exercise
        path(obj.dojo.exercises) + obj.name + '/'
      when Katas
        root(obj.dojo) + 'katas/'
      when Kata
        path(obj.dojo.katas) + obj.id.inner + '/' + obj.id.outer + '/'
      when Avatar
        path(obj.kata) + obj.name + '/'
      when Sandbox
        path(obj.avatar) + 'sandbox/'
    end
  end

  def root(dojo)
    dojo.path
  end

end
