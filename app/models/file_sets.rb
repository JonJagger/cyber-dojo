
class FileSets

  # In a multi-kata dojo, if you list the katas/language
  # filesets alphabetically there is a strong likelihood 
  # each station will simply pick the first entry. That 
  # happened at the 2010 NDC conference for example. Listing 
  # them in a random order increases the chances stations
  # will make different selections, which hopefully will
  # increase the potential for collaboration - the game's
  # prime directive.

  def self.languages
    Dir.entries(RAILS_ROOT + '/languages').select do |name| 
      name != '.' and name != '..'
    end.sort_by {rand}
  end

  def self.katas  
    Dir.entries(RAILS_ROOT + '/katas').select do |name|
      name != '.' and name != '..'
    end.sort_by {rand}
  end

end


