
class DownloaderController < ApplicationController

  # left because will be used to xfer dojos to readonly 2nd server
  # reinstate if anyone asks for this?
  def download    
    # an id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    uuid = Uuid.new(id)
    inner = uuid.inner
    outer = uuid.outer
    cd_cmd = "cd #{cd.dir}/katas"
    tar_cmd = "tar -zcf ../zips/#{id}.tar.gz #{inner}/#{outer}"
    system(cd_cmd + ";" + tar_cmd)
    zip_filename = "#{cd.dir}/zips/#{id}.tar.gz"
    send_file zip_filename
    # would like to delete this zip file
    # but download tests unzip them to verify
    # unzipped zip is identical to original 
    #rm_cmd = "rm #{zip_filename}"
    #system(rm_cmd)
  end

end
