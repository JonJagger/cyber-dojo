#!/bin/bash ../test_wrapper.sh

require_relative 'AppHelpersTestBase'

class TipTests < AppHelpersTestBase

  include TipHelper

  def setup
    super
    set_one_self_class 'OneSelfDummy'
  end
  
  #- - - - - - - - - - - - - - - - - -
  
  test 'FAE414',
  'traffic light count tip' do
    params = {
      'avatar' => 'lion',
      'current_colour' => 'red',
      'red_count' => 14,
      'amber_count' => 3,
      'green_count' => 5,
      'timed_out_count' => 1,
      'bulb_count' => 23
    }
    expected =
      'lion has 23 traffic-lights<br/>' +
      "<div>&bull; 14 <span class='red'>reds</span></div>" +
      "<div>&bull; 3 <span class='amber'>ambers</span></div>" +
      "<div>&bull; 5 <span class='green'>greens</span></div>" +
      "<div>&bull; 1 <span class='timed_out'>timeout</span></div>"
    actual = traffic_light_count_tip_html(params)
    assert_equal expected, actual
  end

  #- - - - - - - - - - - - - - - - - -

  test 'BDAD52',
  'traffic light tip' do
    set_runner_class('RunnerStub')
    set_git_class('GitSpy')
    kata = make_kata
    lion = kata.start_avatar(['lion'])
    
    was_tag = 1
    was_tag_colour = 'red'
    now_tag = 2
    now_tag_colour = 'green'
    lion.dir.write('increments.json',
      [
        { "colour" => was_tag_colour,
          "number" => was_tag,
          "time" => [2015,2,5,9,28,21]
        },
        { "colour" => now_tag_colour,
          "number" => now_tag,
          "time" => [2015,2,5,9,29,15]
        }
      ]
    )

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

    git.spy(lion.path,'diff',options,stub)

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

    git.spy(lion.path,'show',"#{now_tag}:manifest.json", stub_manifest)

    expected =
      "Click to review lion's " +
      "<span class='#{was_tag_colour}'>#{was_tag}</span> " +
      "&harr; " +
      "<span class='#{now_tag_colour}'>#{now_tag}</span> diff" +
      "<div>&bull; 1 added line</div>" +
      "<div>&bull; 1 deleted line</div>"

    actual = traffic_light_tip_html(lion,was_tag,now_tag)

    assert_equal expected, actual
  end

end
