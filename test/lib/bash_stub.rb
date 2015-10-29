
class BashStub

  def initialize
    reset
  end

  attr_reader :spied

  def stub(output, exit_status)
    @stubbed << [output,exit_status]
  end

  def exec(command)
    @spied << command
    stub = @stubbed[@index]
    raise "no stub for command `#{command}`" if stub.nil?
    @index += 1
    return *stub
  end

  def dump
    spied.each_with_index { |line,i| print "\n#{i}:" + line + "\n" }
  end

  def reset
    @stubbed = []
    @spied = []
    @index = 0
  end

end

