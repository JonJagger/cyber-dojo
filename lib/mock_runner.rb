
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

  def run(avatar, delta, files, _image_name, _now, _max_seconds)
    # have to save the files because the effects are
    # asserted in tests and there is no shell_spy yet
    sandbox = avatar.sandbox
    delta[:deleted].each do |filename|
      git.rm(history.path(sandbox), filename)
    end
    delta[:new].each do |filename|
      history.write(sandbox, filename, files[filename])
      git.add(history.path(sandbox), filename)
    end
    delta[:changed].each do |filename|
      history.write(sandbox, filename, files[filename])
    end

    read_mock(avatar)
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
    if dir.exists?(mock_run_filename)
      json = dir.read_json(mock_run_filename)
      output = json['output']
      return output if !output.nil?
      rag = json['colour']
      raise "no 'output' or 'colour' in #{json}" if rag.nil?
      return sample(avatar, rag)
    end
    return sample(avatar, red_amber_green.sample)
  end

  def sample(avatar, rag)
    # ?better in test/languages/test_output
    raise "#{rag} must be red/amber/green" if !red_amber_green.include?(rag)
    root = File.expand_path(File.dirname(__FILE__) + '/../test') + '/app_lib/test_output'
    path = "#{root}/#{avatar.kata.language.unit_test_framework}/#{rag}"
    all_output_samples = disk[path].each_file.collect { |filename| filename }
    filename = all_output_samples.sample
    disk[path].read(filename)
  end

  def red_amber_green
    %w(red amber green)
  end

  def mock_run_filename
    'mock_run.json'
  end

end
