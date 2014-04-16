
class DownloaderController < ApplicationController

  # could be used to xfer dojos to readonly 2nd server?
  # reinstate if anyone asks for this?
  
  def download
    # an dojo-id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    did = Id.new(id)
    cd_cmd = "cd #{dojo.path}/katas"
    tar_cmd = "tar -zcf ../zips/#{did.to_s}.tar.gz #{did.inner}/#{did.outer}"
    system(cd_cmd + ";" + tar_cmd)
    zip_filename = "#{dojo.path}/zips/#{did.to_s}.tar.gz"
    send_file zip_filename
    # would like to delete this zip file
    # but download tests unzip them to verify
    # unzipped zip is identical to original
    #rm_cmd = "rm #{zip_filename}"
    #system(rm_cmd)
  end

end
