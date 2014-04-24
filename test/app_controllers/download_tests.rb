require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DownloadControllerTest < IntegrationTest

  test "downloaded zip of empty dojo with no animals yet unzips to same as original folder" do
    id = checked_save_id
    post 'downloader/download', {
      :id => id
    }
    assert_response :success
    root = Rails.root.to_s + '/test/cyberdojo'
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    verify_zip_unzips_to_same_as_original(root, id, zipfile_name)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "downloaded zip of dojo with one animal unzips to same as original folder" do
    id = checked_save_id

    get 'dojo/enter_json', {
      :id => id
    }
    avatar_name = json['avatar_name']

    get '/kata/edit', {
      :id => id,
      :avatar => avatar_name
    }
    assert_response :success

    post 'kata/run_tests', {
      :id => id,
      :avatar => avatar_name,
      :file_content => {
        'cyber-dojo.sh' => ""
      },
      :file_hashes_incoming => {
        'cyber-dojo.sh' => 234234
      },
      :file_hashes_outgoing => {
        'cyber-dojo.sh' => -4545645678
      }
    }
    post 'downloader/download', {
      :id => id
    }
    assert_response :success
    root = Rails.root.to_s + '/test/cyberdojo'
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    verify_zip_unzips_to_same_as_original(root,id,zipfile_name)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "downloaded zip of dojo with nine animal unzips to same as original folder" do
    id = checked_save_id

    (0..9).each do
      get 'dojo/enter_json', {
        :id => id
      }
      avatar_name = json['avatar_name']

      get '/kata/edit', {
        :id => id,
        :avatar => avatar_name
      }
      assert_response :success

      post 'kata/run_tests', {
        :id => id,
        :avatar => avatar_name,
        :file_content => {
          'cyber-dojo.sh' => ""
        },
        :file_hashes_incoming => {
          'cyber-dojo.sh' => 234234
        },
        :file_hashes_outgoing => {
          'cyber-dojo.sh' => -4545645678
        }
      }
    end

    post 'downloader/download', {
      :id => id
    }
    assert_response :success

    root = Rails.root.to_s + '/test/cyberdojo'
    zipfile_name = root + "/zips/#{id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    verify_zip_unzips_to_same_as_original(root,id,zipfile_name)
  end

  #test "downloaded zip of dojo before git-gc option was added unzips to same as original folder"

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def verify_zip_unzips_to_same_as_original(root, id, zipfile_name)
    uuid = Id.new(id)
    unzip_folder = root + "/zips/unzips"
    `mkdir -p #{unzip_folder}`
    `cd #{unzip_folder};cat #{zipfile_name} | tar xf -`
    src_folder = root + "/katas/#{uuid.inner}/#{uuid.outer}"
    dst_folder = "#{unzip_folder}/#{uuid.inner}/#{uuid.outer}"
    result = `diff -r -q #{src_folder} #{dst_folder}`
    assert_equal "", result, uuid.to_s
  end

end
