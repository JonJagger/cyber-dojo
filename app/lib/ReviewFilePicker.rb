
module ReviewFilePicker # mix-in

  module_function

  def pick_file_id(diffs, current_filename)
    # Prefers to stay on the same file if it still exists
    # in the now_tag (it could have been deleted or renamed)
    # and has at least one change.
    # Otherwise prefers the file with the most changes.
    # If nothing has changed prefers the largest code file
    # (this is likely to be a test file).
    # If no code files! picks cyber-dojo.sh which can never
    # be deleted.

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
      non_code_filenames = %w{ output instructions makefile cyber-dojo.sh }
      code_files = diffs.select { |diff| !non_code_filenames.include? diff[:filename] }
      chosen_diff = code_files.max_by { |diff| diff[:content].size }
    end

    if chosen_diff.nil?
      chosen_diff = diffs.select{|diff| diff[:filename]=='cyber-dojo.sh'}[0]
    end

    chosen_diff[:id]
  end

  def change_count(diff)
    diff[:deleted_line_count] + diff[:added_line_count]
  end

end
