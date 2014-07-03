#!/usr/bin/env ruby

require_relative 'model_test_base'

class IdTests < ModelTestBase

  test "valid? is false when empty-id-string" do
    assert !Id.new("").valid?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'valid? is false when id-string less than 10 chars' do
    valid_id_string.each_char do |char|
      niner = valid_id_string.tr(char,'')
      assert !Id.new(niner).valid?
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'valid? is true for valid 10char id' do
    assert Id.new(valid_id_string).valid?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'valid? is false when id-string contains non-hex char' do
    valid_id_string.each_char do |char|
      bad_chars = "XabcdeG".each_char do |bad_char|
        bad_id = valid_id_string.sub(char, bad_char)
        assert !Id.new(bad_id).valid?
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'generates a valid id when one is not supplied' do
    id = Id.new
    assert id.valid?
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'uses id when supplied (useful for testing)' do
    given = 'ABCDE12345'
    id = Id.new(given)
    assert_equal given, id.to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'id is 10 chars long' do
    assert_equal 10, Id.new.to_s.length
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'id contains only 0-9 and A-E chars' do
    (0..5).each do |n|
      id = Id.new.to_s
      id.chars.each do |char|
        assert "0123456789ABCDEF".include?(char),
             "\"0123456789ABCDEF\".include?(#{char})" + id
      end
    end
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'id.inner is first 2 chars' do
    id = Id.new('1C2345ABDE')
    assert_equal 2, id.inner.length
    assert_equal '1C', id.inner
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'id.outer is last 8 chars' do
    id = Id.new('1C2345ABDE')
    assert_equal 8, id.outer.length
    assert_equal '2345ABDE', id.outer
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is empty string inner ' +
       'and outer return empty string not nil' do
    id = Id.new('')
    assert_equal '', id.inner
    assert_equal '', id.outer
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is one char inner is that char ' +
       'and outer is empty string' do
    id = Id.new('E')
    assert_equal 'E', id.inner
    assert_equal '', id.outer
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is two chars inner is those chars ' +
       'and outer is empty string' do
    id = Id.new('EA')
    assert_equal 'EA', id.inner
    assert_equal '', id.outer
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'when id is three chars inner is first two chars ' +
       'and outer is third char' do
    id = Id.new('EAC')
    assert_equal 'EA', id.inner
    assert_equal 'C', id.outer
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'operator== and operator!=' do
    assert Id.new('ABCDEABCDE') == Id.new('ABCDEABCDE')
    assert Id.new('ABCDEABCDE') != Id.new('1234512345')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def format_3_3_lots(id)
    # idea: massage the uuidgen into an id with
    # format of 3(A-F)letters + 3(0-9)digits
    # to make it more user friendly.
    # analysis: gives 6^3 * 10^3 == 216,000 possibilities
    # outcome: this is too small so I've not used the idea
    chars = id.chars
    letters = chars.select{ |ch| is_letter?(ch) }.join
    digits  = chars.select{ |ch|  is_digit?(ch) }.join
    x,letters = letters.slice!(0...3), letters
    y,digits  =  digits.slice!(0...3), digits
    z = (letters+digits).chars.to_a.shuffle.join
    x + y + z
  end

  def assert_perm(lhs,rhs)
    assert_equal lhs.chars.sort.join,rhs.chars.sort.join
  end

  test 'format33lots with 3+ chars and <3 digits' do
    id = 'CABCDEABCDEABCDFFDDEDDEECFCFCA60'
    nid = format_3_3_lots(id)
    assert_equal 'CAB60',nid[0...5]
    assert_perm 'CDEABCDEABCDFFDDEDDEECFCFCA', nid[5..-1]
  end

  test 'format33lots with <3 chars and 3+ digits' do
    id = 'C5322A80980848728405599701034102'
    nid = format_3_3_lots(id)
    assert_equal 'CA532',nid[0...5]
    assert_perm '280980848728405599701034102', nid[5..-1]
  end

  test 'format33lots with 3+ chars and 3+ digits' do
    id = 'C5322A8C98C8487284F55997F1D341A2'
    nid = format_3_3_lots(id)
    assert_equal 'CAC532',nid[0...6]
    assert_perm 'CFFDA' + '289884872845599713412', nid[6..-1]
  end

  test 'format33lots already in 3,3 prefix' do
    id = 'CAC5322898C8487284F55997F1D341A2'
    nid = format_3_3_lots(id)
    assert_equal 'CAC532',nid[0...6]
    assert_perm 'CFFDA' + '289884872845599713412', nid[6..-1]
  end

  def is_letter?(ch)
    'ABCDEF'.include?(ch)
  end

  def is_digit?(ch)
    '0123456789'.include?(ch)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def valid_id_string
    'ABDEF01289'
  end

end
