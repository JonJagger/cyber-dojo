
module Docker

  def self.installed?
    command = self.stderr2stdout('docker info > /dev/null')
    `#{command}`
    $?.exitstatus === 0
  end

private

  def self.stderr2stdout(cmd)
    cmd + ' 2>&1'
  end

end
