require File.dirname(__FILE__) + '/../test_helper'
require 'Disk'
require 'Git'

class SandboxTests < ActionController::TestCase

  def setup
    Thread.current[:disk] = Disk.new
    Thread.current[:git] = Git.new
    @dojo = Dojo.new(root_path)
  end

  test "defect-driven: filename containing space is not accidentally retained" do
    # retained means stays in the sandbox
    kata = make_kata(@dojo, 'Java-JUnit', exercise='Dummy')
    avatar = kata.start_avatar
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
    traffic_light = OutputParser::parse('junit', output)
    avatar.save_run_tests(visible_files, traffic_light)
    assert_equal 'green', traffic_light['colour']

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
    traffic_light = OutputParser::parse('junit', output)
    assert_equal 'amber', traffic_light['colour']

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
    traffic_light = OutputParser::parse('junit', output)
    avatar.save_run_tests(visible_files, traffic_light)
    # if the file whose name contained a space has been retained
    # this will be :amber instead of :green
    assert_equal 'green', traffic_light['colour'], kata.id + ":" + avatar.name

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
