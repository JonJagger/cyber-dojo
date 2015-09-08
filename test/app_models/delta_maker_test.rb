#!/bin/bash ../test_wrapper.sh

require_relative 'model_test_base'
require_relative 'DeltaMaker'

class DeltaMakerTests < ModelTestBase

  def setup
    super
    kata = make_kata
    avatar = kata.start_avatar(Avatars.names)
    @maker = DeltaMaker.new(avatar)
    @existing_filename = 'cyber-dojo.sh'
    assert @maker.now.keys.include?(@existing_filename)
    @new_filename = 'sal.mon'
    refute @maker.now.keys.include?(@new_filename)
  end

  test 'new_file(filename) raises RuntimeError if filename not new' do
    assert_raises(RuntimeError) { @maker.new_file(@existing_filename, '')}
  end

  test 'new_file(filename) is then not new' do
    @maker.new_file(@new_filename, content='any')    
    assert_raises(RuntimeError) { @maker.new_file(@new_filename, '')}
  end
    
  test 'change_file(filename) raises RuntimeError if filename new' do
    assert_raises(RuntimeError) { @maker.change_file(@new_filename, '') }
  end
  
  test 'change_file(filename) raises RuntimeError if content unchanged' do
    content = @maker.now[@existing_filename]
    assert_raises(RuntimeError) { @maker.change_file(@existing_filename,content) }
  end

  test 'delete_file(filename) raises RuntimeError if filename new' do
    assert_raises(RuntimeError) { @maker.delete_file(@new_filename) }
  end
  
  test 'delete_file(filename) is then not present' do
    @maker.delete_file(@existing_filename)    
    assert_raises(RuntimeError) { @maker.delete_file(@existing_filename)}
  end
  
  test 'new_file(filename) succeeds if filename is new' +
       ', adds filename to visible_files' +
       ', delta[:new] includes filename' do
    content = 'Snaeda'
    @maker.new_file(@new_filename, content)
    delta,now = *@maker.test_args
    assert now.keys.include?(@new_filename)
    assert_equal content,now[@new_filename]
    assert delta[:new].include?(@new_filename)
  end

  test 'change_file(filename) succeeds if filename is not new and content is new' +
       ", updates filename's content in visible_files" +
       ', delta[:changed] includes filename' do
    new_content = 'Snaeda'
    @maker.change_file(@existing_filename, new_content)
    delta,now = *@maker.test_args
    assert now.keys.include?(@existing_filename)
    assert_equal new_content,now[@existing_filename]
    assert delta[:changed].include?(@existing_filename)
  end

  test 'delete_file(filename) succeeds if filename is not new' +
       ', removes filename from visible_files' +
       ', delta[:deleted] includes filename' do
    @maker.delete_file(@existing_filename)
    delta,now = *@maker.test_args
    refute now.keys.include?(@existing_filename) 
    assert delta[:deleted].include?(@existing_filename)
  end
  
end
