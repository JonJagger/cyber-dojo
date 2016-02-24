
# Each GET/POST is serviced in a new thread which creates a
# new dojo object and thus a new runner object. To ensure
# state is preserved from the setup to the call it has
# to be saved to disk and then retrieved.

# TODO: CURRENTLY SAVED TO katas/...
#       NEEDS CHANGING SINCE THAT WILL FILL THE data-container

class StubRunner

  def initialize(dojo)
    @dojo = dojo
  end

  def parent
    @dojo
  end

  def runnable_languages
    languages.select { |language| runnable?(language.image_name) }
  end

  def stub_run_colour(avatar, rag)
    raise "invalid colour #{rag}" if ![:red,:amber,:green].include? rag
    save_stub(avatar, { :colour => rag })
  end

  def stub_run_output(avatar, output)
    save_stub(avatar, { :output => output })
  end

  def run(avatar, _delta, _files, _image_name)
    output = read_stub(avatar)
    max_seconds = @dojo.env('runner', 'timeout')
    output_or_timed_out(output, success=0, max_seconds)
  end

  private

  include ExternalParentChainer
  include Runner

  def runnable?(image_name)
    cdf = 'cyberdojofoundation'
    [
      "#{cdf}/nasm_assert",
      "#{cdf}/gcc_assert",
      "#{cdf}/csharp_nunit"
    ].include?(image_name)
  end

  def save_stub(avatar, json)
    # not good to rely on katas.path here. Would be better if
    # I could get test's hex-id and combine that with avater.name
    katas.dir(avatar).write_json(stub_run_filename, json)
  end

  def read_stub(avatar)
    dir = katas.dir(avatar)
    if dir.exists?(stub_run_filename)
      json = dir.read_json(stub_run_filename)
      output = json['output']
      return output if !output.nil?
      rag = json['colour']
      raise "no 'output' or 'colour' in #{json}" if rag.nil?
      return sample(avatar, rag)
    end
    return sample(avatar, red_amber_green.sample)
  end

  def sample(avatar, rag)
    # ?better in test/languages/outputs
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

  def stub_run_filename
    'stub_run.json'
  end

end
