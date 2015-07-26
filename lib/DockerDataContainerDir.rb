
# Work in Progress. Currently Unused

class DockerDataContainerDir

  def each_kata_id
    # will I have to get all the data container names in one command?
    # ideally I could get them one at a time and yield as I go.
    # Or maybe chunked, eg filter with 2 hex chars to split into 256.
  end
  
  def complete_kata_id(id)
    # I'm assuming [docker ls] can have filters, or this will be slow
  end

end
