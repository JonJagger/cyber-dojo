
class DownloaderController < ApplicationController

  def download
    # an id such as 01FE818E68 corresponds to the folder katas/01/FE818E86
    raise "sorry can't do that" if katas[id].nil?

    cd_cmd = "cd #{katas.path}"
    tar_cmd = "tar -zcf ../zips/#{id}.tar.gz #{outer(id)}/#{inner(id)}"
    cmd = cd_cmd + ' && ' + tar_cmd
    system(cmd)
    zip_filename = "#{katas.path}/../zips/#{id}.tar.gz"
    send_file zip_filename
    # would like to delete this zip file
    # but download tests unzip them to verify
    # unzipped zip is identical to original
    # rm_cmd = "rm #{zip_filename}"
    # `rm_cmd`
  end

  private

  include IdSplitter

end
