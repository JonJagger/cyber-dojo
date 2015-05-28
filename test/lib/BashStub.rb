
class BashStub
  
  def initialize
    @stubbed,@spied = [],[]
    @index = 0
  end

  attr_reader :spied

  def stub(output,exit_status)
    @stubbed << [output,exit_status]
  end
  
  def exec(command)
    @spied << command
    stub = @stubbed[@index]
    @index += 1
    return *stub
  end
  
  def dump
    spied.each_with_index {|line,i| print "\n#{i}:" + line + "\n"}    
  end
  
end

