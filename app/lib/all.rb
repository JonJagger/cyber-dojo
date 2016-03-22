
%w(
  setup_chooser
  file_delta_maker
  git_diff_parser
  git_diff_builder
  git_diff
  line_splitter
  review_file_picker
  prev_next_ring
  makefile_filter
  output_colour
  td_gapper
).each { |sourcefile| require_relative './' + sourcefile }

