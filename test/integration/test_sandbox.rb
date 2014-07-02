#!/usr/bin/env ruby

require_relative '../cyberdojo_test_base'
require_relative 'externals'

class SandboxTests < CyberDojoTestBase

  include Externals

  def setup
    @dojo = Dojo.new(root_path,externals)
  end

  test 'defect-driven: filename containing space ' +
       'is not accidentally retained' do
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

    max_duration = 15
    now = make_time(Time.now)
    lights = avatar.test(delta, visible_files, max_duration, now)
    avatar.save_manifest(visible_files)
    avatar.commit(lights.length)

    assert_equal 1, lights.length
    assert_equal 'green', lights[-1]['colour']

    #- - - - - - - -

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

    max_duration = 15
    now = make_time(Time.now)
    lights = avatar.test(delta, visible_files, max_duration, now)
    avatar.save_manifest(visible_files)
    avatar.commit(lights.length)

    assert_equal 2, lights.length
    assert_equal 'amber', lights[-1]['colour']

    #- - - - - - - -
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

    max_duration = 15
    now = make_time(Time.now)
    lights = avatar.test(delta, visible_files, max_duration, now)
    avatar.save_manifest(visible_files)
    avatar.commit(lights.length)

    assert_equal 3, lights.length
    assert_equal 'green', lights[-1]['colour']

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
