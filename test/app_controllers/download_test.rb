#!/bin/bash ../test_wrapper.sh

require_relative './app_controller_test_base'

class DownloadControllerTest < AppControllerTestBase

  def setup
    super
    @id = create_kata
    kata = katas[@id]
    @tar_dir = "#{katas.path}/../app/downloads/"
    `mkdir -p #{@tar_dir}`
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  prefix = 'C44'

  test prefix+'0EF',
  'download with empty id raises' do
    assert_raises(StandardError) { get 'downloader/download', :id => '' }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'849',
  'download with bad id raises' do
    assert_raises(StandardError) { get 'downloader/download', :id => XX+@id }
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'561',
  'downloaded of empty dojo with no avatars yet untars to same as original folder' do
    get 'downloader/download', :id => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'1B1',
  'downloaded of dojo with one avatar and one traffic-light untars to same as original folder' do
    start
    kata_edit
    change_file('hiker.rb', 'def...')
    run_tests
    get 'downloader/download', :id => @id
    assert_downloaded
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test prefix+'E9B',
  'downloaded of dojo with five animals and five traffic-lights untars to same as original folder' do
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
    tarfile_name = @tar_dir + "/#{@id}.tgz"
    assert File.exists?(tarfile_name), "File.exists?(#{tarfile_name})"
    untar_folder = @tar_dir + '/untar/'
    `mkdir -p #{untar_folder}`
    `cd #{untar_folder} && cat #{tarfile_name} | tar xfz -`
    src_folder = "#{katas.path}/#{outer(@id)}/#{inner(@id)}"
    dst_folder = "#{untar_folder}/#{outer(@id)}/#{inner(@id)}"
    result = `diff -r -q #{src_folder} #{dst_folder}`
    exit_status = $?.exitstatus
    assert_equal 0, exit_status
    assert_equal '', result, @id
  end

  private

  include IdSplitter

end
