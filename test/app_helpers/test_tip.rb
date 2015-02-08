#!/usr/bin/env ruby

require_relative 'app_helpers_test_base'

class TipTests < AppHelpersTestBase

  include TipHelper
  include ExternalSetter

  test 'traffic light tip' do

    reset_external(:disk, DiskFake.new)

    kata = Object.new
    def kata.path; 'katas/12/3456789A/'; end

    avatar = Avatar.new(kata,'hippo')
    was_tag = 1
    now_tag = 2

    avatar.dir.write('increments.json',
      [
        { "colour" => "red",
          "time" => [2015,2,5,9,28,21],
          "number" => was_tag
        },
        { "colour" => "green",
          "time" => [2015,2,5,9,29,15],
          "number" => now_tag
        }
      ]
    )

    git = GitSpy.new
    options =
      "--ignore-space-at-eol " +
      "--find-copies-harder " +
      "#{was_tag} #{now_tag} " +
      "sandbox"

    stub =
    [
      "diff --git a/sandbox/hiker.rb b/sandbox/hiker.rb",
      "index 16c4af7..266c27e 100644",
      "--- a/sandbox/hiker.rb",
      "+++ b/sandbox/hiker.rb",
      "@@ -1,4 +1,4 @@",
      " ",
      " def answer",
      "-  6 * 7sd",
      "+  6 * 7",
      " end"
    ].join("\n")

    git.spy(avatar.path,'diff',options,stub)

    stub_manifest = JSON.unparse(
    { "hiker.rb" =>
        [
          "",
          " def answer",
          "   6 * 7sd",
          " end",
          ""
        ].join("\n")
    })

    git.spy(avatar.path,'show',"#{now_tag}:manifest.json",stub_manifest)

    reset_external(:git, git)

    expected =
      "Click to review hippo&#39;s #{was_tag} &harr; #{now_tag} diff" +
      "<div>&bull; 1 added line</div>" +
      "<div>&bull; 1 deleted line</div>"
    actual = traffic_light_tip(avatar,was_tag,now_tag)
    assert_equal expected, actual
  end

end
