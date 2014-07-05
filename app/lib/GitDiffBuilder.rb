
module GitDiff

  # Combines diff and lines to build a data structure that
  # containes a complete view of a file;
  #    the lines that were deleted
  #    the lines that were added
  #    the lines that were unchanged
  #
  # diff: created from GitDiffParser. The diff between
  #       two tags (run-tests) of a file.
  #
  # lines: an array containing the current content of the
  #        diffed file.

  # The <em>single</em> column of line-numbers on the diff-page is
  # correct when the was_tag minus now_tag difference is 1, which
  # is what it is the vast majority of the time.
  # However when the was_tag minus now_tag is greater than 1
  # this single column approach falls down and you really
  # need two columns of line-numbers. For example, look at the
  # github.com view of a diff.

  class GitDiffBuilder

    def build(diff, lines)
      result = [ ]
      line_number = 1
      from = 0
      index = 0
      diff[:chunks].each do |chunk|
        to = chunk[:range][:now][:start_line] + chunk[:before_lines].length - 1
        line_number = fill(result, :same, lines, from, to, line_number)
        chunk[:sections].each do |section|
          result << { :type => :section, :index => index }
          index += 1
                        fill_all(result, :deleted, section[:deleted_lines], line_number)
          line_number = fill_all(result, :added,   section[:added_lines  ], line_number)
          line_number = fill_all(result, :same,    section[:after_lines  ], line_number)
        end
        from = line_number - 1
      end
      last_lines = lines[line_number-1..lines.length]
      fill_all(result, :same, last_lines, line_number)
      result
    end

  private

    def fill_all(result, type, lines, line_number)
      lines ||= [ ]
      fill(result, type, lines, 0, lines.length, line_number)
    end

    def fill(into, type, lines, from, to, line_number)
      (from...to).each do |n|
        into << {
          :type => type,
          :line => lines[n],
          :number => line_number
        }
        line_number += 1
      end
      line_number
    end

  end

end
