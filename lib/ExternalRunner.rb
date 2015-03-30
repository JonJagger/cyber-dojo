
module ExternalRunner # mixin

  def runner
    @runner ||= Object.const_get(runner_class_name).new
  end

  def runner?
    !runner_class_name.nil?
  end
  
  def runner_class_name
    ENV[runner_key]
  end
  
  def set_runner_class_name(value)
    ENV[runner_key] = value
  end

private

  def runner_key
    'CYBER_DOJO_RUNNER_CLASS_NAME'
  end

end
