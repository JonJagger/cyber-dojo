#!/bin/bash ../test_wrapper.sh

require_relative 'AppControllerTestBase'

class DownloadControllerTest < AppControllerTestBase

=begin
  test 'downloaded zip of empty dojo with no animals yet ' +
       'unzips to same as original folder' do
    id = checked_save_id
    post 'downloader/download', :id => id
    assert_response :success
    root = Rails.root.to_s + '/test/cyberdojo'
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    verify_zip_unzips_to_same_as_original(root, id, zipfile_name)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'downloaded zip of dojo with one animal ' +
       'unzips to same as original folder' do
    @id = checked_save_id
    enter
    kata_edit

    kata_run_tests :file_content => {
        'cyber-dojo.sh' => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }

    post 'downloader/download', :id => @id
    assert_response :success
    root = Rails.root.to_s + '/test/cyberdojo'
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    verify_zip_unzips_to_same_as_original(root,id,zipfile_name)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'downloaded zip of dojo with five animals unzips ' +
       'to same as original folder' do
    @id = checked_save_id

    9.times do
      enter
      kata_edit

      kata_run_tests :file_content => {
          'cyber-dojo.sh' => ""
        },
        :file_hashes_incoming => {
          'cyber-dojo.sh' => 234234
        },
        :file_hashes_outgoing => {
          'cyber-dojo.sh' => -4545645678
        }
    end

    post 'downloader/download', :id => @id
    assert_response :success

    root = Rails.root.to_s + '/test/cyberdojo'
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    verify_zip_unzips_to_same_as_original(root,id,zipfile_name)
  end
=end


  #test "downloaded zip of dojo before git-gc option was added unzips to same as original folder"

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def verify_zip_unzips_to_same_as_original(root, id, zipfile_name)
    unzip_folder = root + "/zips/unzips"
    `mkdir -p #{unzip_folder}`
    `cd #{unzip_folder};cat #{zipfile_name} | tar xf -`
    src_folder = root + "/katas/#{outer(id)}/#{inner(id)}"
    dst_folder = "#{unzip_folder}/#{outer(id)}/#{inner(id)}"
    result = `diff -r -q #{src_folder} #{dst_folder}`
    assert_equal "", result, id
  end

  def outer(id)
    id[0..1]
  end

  def inner(id)
    id[2..-1]
  end

end
