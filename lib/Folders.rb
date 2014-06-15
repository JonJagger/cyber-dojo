
module Folders

  def self.id_complete(root_dir, id)
    if !id.nil?
      id = id[0...10].upcase
      # if at least 4 characters of the id are
      # provided attempt to do id-completion
      # Doing completion with fewer characters would likely result
      # in a lot of disk activity and no unique outcome
      if id.length >= 4 && id.length < 10
        dirs = Dir[root_dir + id[0...2] + '/' + id[2..-1] + '*']
        if dirs.length == 1
          dir = dirs[0]
          id = dir[dir.length-12..-1].tr('//', '')
        end
      end
    end
    id
  end

  # TODO: refactor this to katas.complete(id)
  # this will mean I need a Disk.match(path)
  # feature - currently the Disk design has enforced
  # end-slash on Disk.subdirs()

end