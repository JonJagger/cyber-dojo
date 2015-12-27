
# Each GET/POST is serviced in a new thread which creates a
# new dojo object and thus a new runner object. To ensure
# state is preserved from the setup to the call it has
# to be saved to disk and then retrieved.

class MockRunner

  def initialize(dojo)
    @dojo = dojo
  end

  def parent
    @dojo
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  def mock_run_colour(avatar, rag)
    raise "invalid colour #{rag}" if ![:red,:amber,:green].include? rag
    save_mock(avatar, { :colour => rag })
  end

  def mock_run_output(avatar, output)
    save_mock(avatar, { :output => output })
  end

  def run(sandbox, max_seconds)
    read_mock(sandbox.avatar)
  end

  private

  include ExternalParentChainer

  def runnable?(image_name)
    cdf = 'cyberdojofoundation'
    [
      "#{cdf}/nasm_assert",
      "#{cdf}/gcc_assert",
      "#{cdf}/csharp_nunit"
    ].include?(image_name)
  end

  def save_mock(avatar, json)
    disk[avatar.path].write_json(mock_run_filename, json)
  end

  def read_mock(avatar)
    dir = disk[avatar.path]
    return 'anything' if !dir.exists?(mock_run_filename)
    json = dir.read_json(mock_run_filename)
    output = json['output']
    return output if !output.nil?
    rag = json['colour']
    return sample(avatar, rag) if !rag.nil?
    raise "no 'output' or 'colour' key in #{json}"
  end

  def sample(avatar, rag)
    # ?better in test/languages/test_output
    root = File.expand_path(File.dirname(__FILE__) + '/../test') + '/app_lib/test_output'
    path = "#{root}/#{avatar.kata.language.unit_test_framework}/#{rag}"
    all_outputs = disk[path].each_file.collect { |filename| filename }
    filename = all_outputs.sample
    disk[path].read(filename)
  end

  def mock_run_filename
    'mock_run.json'
  end

end
