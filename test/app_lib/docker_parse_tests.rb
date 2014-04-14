require File.dirname(__FILE__) + '/../test_helper'

class DockerParseTests < ActionController::TestCase

  test "parse 'docker images' output in prep for languages_each()" do
    output = [
      "REPOSITORY                            TAG                 IMAGE ID            CREATED             VIRTUAL SIZE",
      "cyberdojo/language_ruby-1.9.3         latest              48f93a0a2bb4        3 hours ago         328.3 MB",
      "cyberdojo/language_gcc-4.8.1_assert   latest              e8ac00b6fa7b        3 hours ago         310.6 MB",
      "cyberdojo/language_gpp-4.8.1_assert   latest              e8ac00b6fa7b        3 hours ago         310.6 MB",
      "cyberdojo/build-essential             latest              bc54c666c7c1        6 hours ago         310.6 MB",
      "ubuntu                                13.10               9f676bd305a4        7 weeks ago         178 MB",
      "ubuntu                                saucy               9f676bd305a4        7 weeks ago         178 MB",
    ].join("\n")

    repos = output.lines.each.collect{|line| line.split[0]}.select{|repo|
      repo.start_with? 'cyberdojo/language_'
    }
    assert_equal [
      'cyberdojo/language_ruby-1.9.3',
      'cyberdojo/language_gcc-4.8.1_assert',
      'cyberdojo/language_gpp-4.8.1_assert',
    ].sort, repos.sort
  end

end
