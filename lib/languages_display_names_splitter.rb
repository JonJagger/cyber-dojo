
class LanguagesDisplayNamesSplitter

  def initialize(display_names, selected_index)
    @display_names = display_names
    @selected_index = selected_index
  end

  def names
    @names ||= split(0)
  end

  def selected_index
    name = @display_names[@selected_index].split(',')[0].strip
    names.index(name)
  end

  def tests_names
    @tests_names ||= split(1)
  end

  def tests_indexes
    names.map { |name| make_test_indexes(name) }
  end

private

  def split(n)
    @display_names.map { |name| name.split(',')[n].strip }.sort.uniq
  end

  def make_test_indexes(language_name)
    result = []
    @display_names.each do |name|
      if name.start_with?(language_name + ',')
        test_name = name.split(',')[1].strip
        result << tests_names.index(test_name)
      end
    end
    result.shuffle

    # if this is the tests index array for the selected-language
    # then make sure the index for the selected-language's test
    # is at position zero.
    # Why?
    # See /app/views/setup/_list_languages.hmtl.erb
    #     8     data-test-index="<%= @split.tests_indexes[index][0] %>"
    #
    # and /app/views/setup/_chooser.html.erb
    #     25 var ti = language.data('test-index');
    #     26 $('[id=test_' + ti +']').click();
    #
    # These ensure the initial selection of the language causes the correct
    # initial selection of the test for that language.

    if language_name == names[selected_index]
      test_name = @display_names[@selected_index].split(',')[1].strip
      test_index = tests_names.index(test_name)
      result.delete(test_index)
      result.unshift(test_index)
    end

    result
  end

end
