
class Sandbox

  def initialize(avatar)
    @avatar = avatar
  end

  # queries

  attr_reader :avatar

  def parent
    avatar
  end

  def path
    history.path(self)
  end

  private

  include ExternalParentChainer

end
