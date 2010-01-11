
{
  :visible_files =>
  {
    'unsplice.tests.c' => {},
    'unsplice.c' => {},
    'unsplice.h' => {},
    'notes.txt' => {},
    'run_tests_output' => {},
    'instructions' => {},
  },

  :hidden_files =>
  {
    'makefile' => {},
    'tequila.h' => {},
    'tequila.c' => {},
    'kata.sh' => { :permissions => 0755 },
  },

  :language => 'c',

  :unit_test_framework => 'tequila',

  :max_run_tests_duration => 10,
}

