
class DownloaderController < ApplicationController

  def download
    # an id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    cd_cmd = "cd #{dojo.path}/katas"
    tar_cmd = "tar -zcf ../zips/#{id}.tar.gz #{outer(id)}/#{inner(id)}"
    system(cd_cmd + ";" + tar_cmd)
    zip_filename = "#{dojo.path}/zips/#{id}.tar.gz"
    send_file zip_filename
    # would like to delete this zip file
    # but download tests unzip them to verify
    # unzipped zip is identical to original
    # rm_cmd = "rm #{zip_filename}"
    # `rm_cmd`
  end

private

  def outer(id)
    id[0..1]
  end

  def inner(id)
    id[2..-1]
  end

end
