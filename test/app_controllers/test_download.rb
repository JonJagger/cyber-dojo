#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class DownloadControllerTest < AppControllerTestBase

  def setup
    super
    @id = create_kata
    kata = katas[@id]
    @zip_dir = "#{katas.path(katas)}/../zips/"
    `mkdir -p #{@zip_dir}`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'C440EF',
  'download with empty id raises' do
    assert_raises(StandardError) { get 'downloader/download', :id => '' }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '03F849',
  'download with bad id raises' do
    assert_raises(StandardError) { get 'downloader/download', :id => XX+@id }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '681561',
  'downloaded zip of empty dojo with no animals yet unzips to same as original folder' do
    get 'downloader/download', :id => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '4051B1',
  'downloaded zip of dojo with one avatar and one traffic-light unzips to same as original folder' do
    start
    kata_edit
    change_file('hiker.rb', 'def...')
    run_tests
    get 'downloader/download', :id => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '987E9B',
  'downloaded zip of dojo with five animals and five traffic-lights unzips to same as original folder' do
    5.times do
      start
      kata_edit
      change_file('hiker.rb', 'def...')
      run_tests
      change_file('test_hiker.rb', 'def...')
      run_tests
    end
    get 'downloader/download', :id => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def assert_downloaded
    assert_response :success
    zipfile_name = @zip_dir + "/#{@id}.tar.gz"
    assert File.exists?(zipfile_name), "File.exists?(#{zipfile_name})"
    unzip_folder = @zip_dir + '/unzips/'
    `mkdir -p #{unzip_folder}`
    `cd #{unzip_folder} && cat #{zipfile_name} | tar xfz -`
    src_folder = @zip_dir + "../katas/#{outer(@id)}/#{inner(@id)}"
    dst_folder = "#{unzip_folder}/#{outer(@id)}/#{inner(@id)}"
    result = `diff -r -q #{src_folder} #{dst_folder}`
    assert_equal '', result, @id
  end

  private

  include IdSplitter

end
