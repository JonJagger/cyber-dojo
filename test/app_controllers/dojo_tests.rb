require File.dirname(__FILE__) + '/../test_helper'
require './integration_test'

class DojoControllerTest  < IntegrationTest

  test "index" do
    get 'dojo/index'
    assert_response :success
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=false if no kata for id" do
    id = 'abcdef'

    get 'dojo/valid_id',
      :format => :json,
      :id => id

    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=false if id.length < 6 and kata exists" do
    id = checked_save_id[0..4]
    assert id.length < 6

    get 'dojo/valid_id',
      :format => :json,
      :id => id

    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=true if id.length == 6 and kata exists" do
    id = checked_save_id[0..5]
    assert id.length == 6

    get 'dojo/valid_id',
      :format => :json,
      :id => id

    assert json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "valid_id exists=true if id.length > 6 and kata exists" do
    id = checked_save_id[0..6]
    assert id.length > 6

    get 'dojo/valid_id',
      :format => :json,
      :id => id

    assert json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  # Trying to track down a fault which results in
  # .../katas/hippo/.git
  # being created rather than .../katas/34/76ED5521/hippo/.git
  # dojo_controller.rb enter_json() does this...
  #     kata = dojo.katas[id]
  #     exists = kata.exists?
  #     avatar = (exists ? kata.start_avatar : nil)
  #
  # and kata.start_avatar() does this...
  #    paas.start_avatar(self, names)
  #
  # and paas.start_avatar() does this...
  #    make_dir(avatar)
  #    git_init(avatar, '--quiet')
  #
  # and paas.make_dir() does this...
  #    dir(object).make
  #
  # and dir(object) does this..
  #    disk[path(obj)]
  #
  # and path(obj) does this...
  #   when Kata
  #      path(obj.dojo.katas) + obj.id.inner + '/' + obj.id.outer + '/'
  #    when Avatar
  #      path(obj.kata) + obj.name + '/'
  #
  # now, if obj.id is the empty string this will result in
  #    disk['.../katas///hippo'].make
  #
  # and OsDir.make() does this...
  #    FileUtils.mkdir_p(path)
  #
  # and FileUtils.mkdir_p('.../katas///hippo')
  # works and does indeed create .../katas/hippo
  # The slashes collapse.
  #
  # So next up is
  #    git_init(avatar, '--quiet')
  #
  # and git_init() does this...
  #     @git.init(path(object), args)
  #
  # and git.init() does this...
  #    run(dir, 'init', args)
  #
  # and git.run() does this...
  #    `cd #{dir}; git #{command} #{args}`
  #
  # which will be
  #    'cd .../katas///hippo; git init --quiet'
  #
  # and once again, the /// slashes collapse
  # and this does indeed create a git repo in
  # ./katas/hippo
  #
  # So it appears that in...
  #
  #     kata = dojo.katas[id]
  #     exists = kata.exists?
  #     avatar = (exists ? kata.start_avatar : nil)
  #
  # we are getting to the last line and calling
  # kata.start_avatar with an id==""
  # This implies exists? is true
  # This implies kata.exists? is also true
  # But I cannot see how kata.exists? is true when id="" in
  #     kata = dojo.katas[id]
  #
  # The hunt continues...




  # - - - - - - - - - - - - - - - - - - - - - -

  test "enter_json with empty string id => !exists" do
    bad_id = ''

    get 'dojo/enter_json',
      :format => :json,
      :id => bad_id

    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "enter_json with id that does not exist => !exists" do
    bad_id = 'ab00ab11ab'

    get 'dojo/enter_json',
      :format => :json,
      :id => bad_id

    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "enter_json with id that does exist => exists,!full,avatar_name" do
    id = checked_save_id

    get 'dojo/enter_json',
      :format => :json,
      :id => id

    assert json['exists']
    assert !json['full']
    assert_not_nil json['avatar_name']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "enter succeeds once for each avatar name, then dojo is full" do
    id = checked_save_id
    Avatars.names.each do |avatar_name|

      get '/dojo/enter_json',
        :format => :json,
        :id => id

      assert json['exists']
      assert !json['full']
      assert_not_nil json['avatar_name']
    end

    get '/dojo/enter_json',
      :format => :json,
      :id => id

    assert json['exists']
    assert json['full']
    assert_nil json['avatar_name']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "re_enter_json with id that does not exist" do
    bad_id = 'ab00ab11ab'

    get 'dojo/re_enter_json',
      :format => :json,
      :id => bad_id

    assert !json['exists']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "re_enter_json with id that exists but is empty" do
    id = checked_save_id

    get 'dojo/re_enter_json',
      :format => :json,
      :id => id

    assert json['exists']
    assert json['empty']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "re_enter_json with id that exists and is not empty" do
    id = checked_save_id

    get '/dojo/enter_json',
      :format => :json,
      :id => id

    get 'dojo/re_enter_json',
      :format => :json,
      :id => id

    assert json['exists']
    assert !json['empty']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  test "button dialogs" do
    buttons = %w( about donators give-feedback get-started faqs tips why )
    buttons.each do |name|

      get 'dojo/button_dialog',
        :id => name

      assert_response :success
    end
  end

end
