#!/bin/bash ../test_wrapper.sh

require_relative './lib_test_base'

class LogDemo
  def initialize(root)
    @root = root
    @messages = []
  end
  def m(*args)
    @messages << args
    args
  end
  def messages
    @messages
  end
end

# - - - - - - - - - - - - - - - -

class GrandMother

  def path
    'grand_mother/'
  end

  def log; @log ||= LogDemo.new(self); end

end

# - - - - - - - - - - - - - - - -

class Mother

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def path
    parent.path + 'mother/'
  end

  private

  include ExternalParentChainer

end

# - - - - - - - - - - - - - - - -

class Daughter

  def initialize(parent)
    @parent = parent
  end

  attr_reader :parent

  def path
    parent.path + 'daughter/'
  end

  include ExternalParentChainer

end

# - - - - - - - - - - - - - - - -

class ExternalParentChainerTests < LibTestBase

  def setup
    super
    @edna = GrandMother.new
    @margaret = Mother.new(@edna)
    @ellie = Daughter.new(@margaret)
  end

  attr_reader :edna, :margaret, :ellie

  # - - - - - - - - - - - - - - - - - - - - -

  test '67A467',
  'objects are chained together using parent and paths use parent property' do
    assert_equal 'Daughter', ellie.class.name
    assert_equal 'Mother', ellie.parent.class.name
    assert_equal 'GrandMother', ellie.parent.parent.class.name
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '4271A8',
  'method_missing finds first object without a parent and delegates to it' do
    assert_equal 'grand_mother/', edna.path
    assert_equal 'grand_mother/mother/', margaret.path
    assert_equal 'grand_mother/mother/daughter/', ellie.path

    assert_equal [1,2,3], ellie.log.m(1,2,3)
    assert_equal ['s'], ellie.log.m('s')
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test 'EA58E0',
  'log retains its state across calls' do
    ellie.log.m(1,2,3)
    ellie.log.m('s')
    margaret.log.m(6,7,8)
    assert_equal [[1,2,3],['s'],[6,7,8]], edna.log.messages
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '5BBF52',
  'passing args to root object raises' do
    ellie.log
    raised = assert_raises(RuntimeError) { ellie.log(42) }
    assert_equal "not-expecting-arguments [42]", raised.message
    raised = assert_raises(RuntimeError) { ellie.log(4, 2) }
    assert_equal "not-expecting-arguments [4, 2]", raised.message
  end

  # - - - - - - - - - - - - - - - - - - - - -

  test '397B16',
  'root object has no parent, does not include chainer, but still has the log' do
    ellie.log.m(1,2)
    ellie.log.m('Tay')
    assert_equal [[1,2],['Tay']], edna.log.messages
  end

end





