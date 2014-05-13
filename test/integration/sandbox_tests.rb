require File.dirname(__FILE__) + '/../test_helper'
require 'OsDisk'
require 'Git'
require 'HostRunner'

class SandboxTests < ActionController::TestCase

  def setup
    disk   = OsDisk.new
    git    = Git.new
    runner = HostRunner.new
    paas = LinuxPaas.new(disk, git, runner)
    @dojo = paas.create_dojo(root_path)
  end

  test "defect-driven: filename containing space is not accidentally retained" do
    # retained means stays in the sandbox
    kata = make_kata(@dojo, 'test-Java-JUnit')
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

    avatar.save(delta, visible_files)
    max_duration = 15
    output = avatar.test(max_duration)
    traffic_light = OutputParser::parse(avatar.kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    avatar.commit(traffic_lights.length)

    assert_equal 'green', traffic_light['colour']

    SPACE = ' '
    visible_files = {
      'Untitled' + SPACE + '.java'    => content_for_untitled_java,
      'UntitledTest.java' => content_for_untitled_test_java,
      'cyber-dojo.sh'     => content_for_cyber_dojo_sh
    }
    delta = {
      :unchanged => [ 'cyber-dojo.sh', 'UntitledTest.java' ],
      :changed   => [ ],
      :deleted   => [ 'Untitled.java' ],
      :new       => [ 'Untitled' + SPACE + '.java' ]
    }

    avatar.save(delta, visible_files)
    output = avatar.test(max_duration)
    traffic_light = OutputParser::parse(avatar.kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    avatar.commit(traffic_lights.length)

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

    avatar.save(delta, visible_files)
    output = avatar.test(max_duration)
    traffic_light = OutputParser::parse(avatar.kata.language.unit_test_framework, output)
    traffic_lights = avatar.save_traffic_light(traffic_light, make_time(Time.now))
    avatar.commit(traffic_lights.length)

    # if the file whose name contained a space has been retained
    # this will be :amber instead of :green
    assert_equal 'green', traffic_light['colour'], kata.id.to_s + ":" + avatar.name
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
