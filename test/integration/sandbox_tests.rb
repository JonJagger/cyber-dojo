require File.dirname(__FILE__) + '/../coverage_test_helper'

class SandboxTests < ActionController::TestCase

  def root_dir
    (Rails.root + 'test/cyberdojo').to_s
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test "defect-driven: filename containing space is not accidentally retained" do
    # retained means stays in the sandbox
    teardown
    kata = make_kata('Java-JUnit', exercise='Dummy')
    avatar_name = Avatar::names.shuffle[0]
    avatar = Avatar.create(kata, avatar_name)
    
    id = kata.id
    kata = Kata.new(root_dir, id)
    sandbox = avatar.sandbox
    
    visible_files = {
      'Untitled.java'     => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh'     => content_for_cyber_dojo_sh
    }
    delta = {
      :unchanged => [ ],
      :changed   => [ 'cyber-dojo.sh', 'UntitledTest.java', 'Untitled.java' ],
      :deleted   => [ ],
      :new       => [ ]
    }
    output = sandbox.test(delta, visible_files)    
    traffic_light = CodeOutputParser::parse('junit', output)
    avatar.save_run_tests(visible_files, traffic_light)
    assert_equal :green, traffic_light[:colour]
    
    visible_files = {
      'Untitled .java'    => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh'     => content_for_cyber_dojo_sh
    }
    delta = {
      :unchanged => [ 'cyber-dojo.sh', 'UntitledTest.java' ],
      :changed   => [ ],
      :deleted   => [ 'Untitled.java' ],
      :new       => [ 'Untitled .java' ]
    }
    output = sandbox.test(delta, visible_files)
    avatar.save_run_tests(visible_files, traffic_light)      
    traffic_light = CodeOutputParser::parse('junit', output)
    assert_equal :amber, traffic_light[:colour]
    
    # put it back the way it was
    visible_files = {
      'Untitled.java'     => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh'     => content_for_cyber_dojo_sh
    }
    delta = {
      :changed   => [ ],
      :unchanged => [ 'cyber-dojo.sh', 'UntitledTest.java', 'Untitled.java' ],
      :deleted   => [ 'Untitled .java' ],
      :new       => [ 'Untitled.java' ]
    }
    output = sandbox.test(delta, visible_files)    
    traffic_light = CodeOutputParser::parse('junit', output)
    avatar.save_run_tests(visible_files, traffic_light)
    # if the file whose name contained a space has been retained
    # this will be :amber instead of :green
    assert_equal :green, traffic_light[:colour], id + ":" + avatar_name
    
  end
  
  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  def content_for_untitled_java
    [
      "public class Untitled { ",
      "    public static int answer() { ",
      "        return 42;",
      "    }",
      "}"
    ].join("\n")
  end
  
  def content_for_untitled_test_java
    [
      "import org.junit.*;",
      "import static org.junit.Assert.*;",
      "",
      "public class UntitledTest {",
      "",    
      "    @Test",
      "    public void hitch_hiker() {",
      "        int expected = 6 * 7;",
      "        int actual = Untitled.answer();",
      "        assertEquals(expected, actual);",
      "    }",
      "}"
    ].join("\n")
  end
  
  def content_for_cyber_dojo_sh
    [
      "rm -f *.class",
      "javac -cp .:./junit-4.11.jar *.java ",
      "if [ $? -eq 0 ]; then",
      "  java -cp .:./junit-4.11.jar org.junit.runner.JUnitCore `ls -1 *Test*.class | grep -v '\\$' | sed 's/\(.*\)\..*/\1/'`",
      "fi"
    ].join("\n")
  end
  
end

