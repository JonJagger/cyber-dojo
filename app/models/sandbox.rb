
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  # queries

  attr_reader :avatar

  def parent
    avatar
  end

  private

  include ExternalParentChainer

end
