require_relative 'GitDiffBuilder'
require_relative 'GitDiffParser'
require_relative 'LineSplitter'

module GitDiff

  # Top level functions used by diff_controller.rb to create
  # data structure (to build view from) containing diffs
  # for all files, for a given avatar, for a given tag.

  def git_diff(diff_lines, visible_files)
      view = { }
      diffs = GitDiffParser.new(diff_lines).parse_all
      diffs.each do |sandbox_name,diff|
        md = %r|^(.)/sandbox/(.*)|.match(sandbox_name)
        if md
          filename = md[2]
          if deleted_file?(md[1])
            file_content = [ ]
            if diff[:chunks] != [ ] #[ ] indicates empty file was deleted
              file_content = diff[:chunks][0][:sections][0][:deleted_lines]
            end
            view[filename] = deleteify(file_content)
          else
            file_content = visible_files[filename]
            view[filename] = GitDiffBuilder.new().build(diff, LineSplitter.line_split(file_content))
          end
          visible_files.delete(filename)
        end
      end

      # other files have not changed...
      visible_files.each do |filename,content|
        view[filename] = sameify(content)
      end

      view
  end

  #-----------------------------------------------------------

  def deleted_file?(ch)
    # GitDiffParser uses names beginning with
    # a/... to indicate a deleted file
    # b/... to indicate a new/modified file
    # This mirrors the git diff command output
    ch == 'a'
  end

  #-----------------------------------------------------------

  def sameify(source)
    ify(LineSplitter.line_split(source), :same)
  end

  #-----------------------------------------------------------

  def deleteify(lines)
    ify(lines, :deleted)
  end

  #-----------------------------------------------------------

  def ify(lines, type)
    lines.collect.each_with_index do |line, number|
      {
        :line => line,
        :type => type,
        :number => number + 1
      }
    end
  end

  #############################################################

  def most_changed_file_id(diffs, current_filename)
    # Prefers to stay on the same file if it still exists
    # in the now_tag (it could have been deleted or renamed)
    # and has at least one change.
    # Otherwise prefers the file with the most changes.
    # If nothing has changed prefers the largest file
    # that isn't output or instructions (this is likely to
    # be a test file).

    chosen_diff = nil
    current_filename_diff = diffs.find { |diff| diff[:filename] == current_filename }

    files = diffs.select { |diff| diff[:filename] != 'output' && diff[:filename] != current_filename }
    files = files.select { |diff| change_count(diff) > 0 }
    most_changed_diff = files.max { |lhs,rhs| change_count(lhs) <=> change_count(rhs) }

    if !current_filename_diff.nil?
      if change_count(current_filename_diff) > 0 || most_changed_diff.nil?
        chosen_diff = current_filename_diff
      else
        chosen_diff = most_changed_diff
      end
    elsif !most_changed_diff.nil?
      chosen_diff = most_changed_diff
    else
      diffs = diffs.select { |diff| diff[:filename] != 'output' && diff[:filename] != 'instructions' }
      chosen_diff = diffs.max_by { |diff| diff[:content].size }
    end

    chosen_diff[:id]
  end

  #-----------------------------------------------------------

  def change_count(diff)
    diff[:deleted_line_count] + diff[:added_line_count]
  end

  #############################################################

  def git_diff_view(diffed_files)
    n = 0
    diffs = [ ]
    diffed_files.sort.each do |filename,diff|
      id = 'id_' + n.to_s
      n += 1
      diffs << {
        :id => id,
        :filename => filename,
        :section_count      => diff.count { |line| line[:type] == :section },
        :deleted_line_count => diff.count { |line| line[:type] == :deleted },
        :added_line_count   => diff.count { |line| line[:type] == :added   },
        :content  => git_diff_html_file(id, diff),
        :line_numbers => git_diff_html_line_numbers(diff)
      }
    end
    diffs
  end

  #-----------------------------------------------------------

  def git_diff_html_file(id, diff)
    lines = diff.map {|n| diff_htmlify(id, n) }.join('')
  end

  #-----------------------------------------------------------

  def diff_htmlify(id, n)
    result = ''
    if n[:type] == :section
      result = "<span id='#{id}_section_#{n[:index]}'></span>"
    else
      line = CGI.escapeHTML(n[:line])
      line = '&thinsp;' if line == ''
      result =
        "<#{n[:type]}>" +
          line +
        "</#{n[:type]}>"
    end
    result
  end

  #-----------------------------------------------------------
  # Originally I left-padded each line-number.
  # Now I don't and the CSS right-aligns the line-numbers.
  # There is a downside to this approach however.
  # If I have two files in the diff-view and one has less
  # than 10 lines and the other has more than 10 lines then
  # the first one's line-numbers will be 2 chars wide and the
  # seconds one's line-numbers will be 3 chars wide. This
  # will make the left edge of a file's content move
  # horizontally when you switch between these two files.
  # In practice I've decided this is not worth worrying about
  # since the overwhelming feeling you get when switching files
  # is the change of content anyway.

  def git_diff_html_line_numbers(diff)
    line_numbers = diff.map {|n| diff_htmlify_line_numbers(n) }.join('')
  end

  def diff_htmlify_line_numbers(n)
    result = ''
    if n[:type] != :section
      result =
        "<#{n[:type]}>" +
          '<ln>' + n[:number].to_s + '</ln>' +
        "</#{n[:type]}>"
    end
    result
  end

end
