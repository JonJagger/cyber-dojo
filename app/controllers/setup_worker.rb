
module SetupWorker # mixin
  
  include ExternalDiskDir
  include Chooser
  
  def read_languages
    dir = disk[dojo.languages.path]
    if dir.exists?(cache_filename)
      # languages/cache.json is created with languages/cache.rb
      languages = JSON.parse(dir.read(cache_filename)).sort
    else
      languages = dojo.languages.each.select{ |language|
        language.runnable?
      }.map{ |language|
        [language.display_name,language.name]
      }.sort
    end
    languages_names = languages.map{|array| array[1]}
    
    [languages,languages_names]
  end

  def read_exercises
    dir = disk[dojo.exercises.path]
    if dir.exists?(cache_filename)
      # exercises/cache.json is created with exercises/cache.rb
      cache = JSON.parse(dir.read(cache_filename)).sort
      exercises_names = cache.map{|one| one[0]}
      instructions = Hash[cache]
    else
      exercises_names = dojo.exercises.each.map{ |exercise|
        exercise.name
      }.sort
      instructions = Hash[exercises_names.collect{ |name|
        [name, dojo.exercises[name].instructions]
      }]
    end
    [exercises_names,instructions]
  end

  def cache_filename
    'cache.json'
  end

end
