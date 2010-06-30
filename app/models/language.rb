
class Language

  def self.names
    # In a multi-language dojo, if you list the languages 
    # alphabetically there is a strong likelihood that each
    # station will simply pick the first entry.
    # Listing the languages in a random increases the chances
    # multiple languages will be selected, which hopefully
    # will increase the chances of collaboration - the game's
    # prime directive.
    Dir.entries(RAILS_ROOT + '/languages').select do |name| 
      name != '.' and name != '..'
    end.sort_by {rand}
  end
  
end


