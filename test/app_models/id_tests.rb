require File.dirname(__FILE__) + '/../test_helper'

class IdTests < ActionController::TestCase

  test "valid? is false if empty-id-string" do
    assert !Id.new("").valid?
  end

  def valid_id_string
    'ABDEF01289'
  end

  test "valid? is false if id-string less than 10 chars" do
    valid_id_string.each_char do |char|
      niner = valid_id_string.tr(char,'')
      assert !Id.new(niner).valid?
    end
  end

  test "valid? is true for valid 10char id" do
    assert Id.new(valid_id_string).valid?
  end

  test "valid? is false if id-string contains non-hex char" do
    valid_id_string.each_char do |char|
      bad_chars = "XabcdeG".each_char do |bad_char|
        bad_id = valid_id_string.sub(char, bad_char)
        assert !Id.new(bad_id).valid?
      end
    end
  end

  test "generates a valid id if one is not supplied" do
    id = Id.new
    assert id.valid?
  end

  test "uses id if supplied (useful for testing)" do
    given = 'ABCDE12345'
    id = Id.new(given)
    assert_equal given, id.to_s
  end

  test "id is 10 chars long" do
    assert_equal 10, Id.new.to_s.length
  end

  test "id contains only 0-9 and A-E chars" do
    (0..20).each do |n|
      id = Id.new.to_s
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end
    end
  end

  test "id.inner is first 2 chars" do
    id = Id.new('1C2345ABDE')
    assert_equal 2, id.inner.length
    assert_equal '1C', id.inner
  end

  test "id.outer is last 8 chars" do
    id = Id.new('1C2345ABDE')
    assert_equal 8, id.outer.length
    assert_equal '2345ABDE', id.outer
  end

  test "when id is empty string inner and outer return empty string not nil" do
    id = Id.new('')
    assert_equal '', id.inner
    assert_equal '', id.outer
  end

  test "when id is one char inner is that char and outer is empty string" do
    id = Id.new('E')
    assert_equal 'E', id.inner
    assert_equal '', id.outer
  end

  test "when id is two chars inner is those chars and outer is empty string" do
    id = Id.new('EA')
    assert_equal 'EA', id.inner
    assert_equal '', id.outer
  end

  test "when id is three chars inner is first two chars and outer is third char" do
    id = Id.new('EAC')
    assert_equal 'EA', id.inner
    assert_equal 'C', id.outer
  end

  test "operator==" do
    assert Id.new('ABCDEABCDE') == Id.new('ABCDEABCDE')
    assert Id.new('ABCDEABCDE') != Id.new('1234512345')
  end

end
