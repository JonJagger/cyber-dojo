
class Tags
  include Enumerable

  def initialize(avatar)
    @avatar = avatar
  end

  def [](n)
    Tag.new(@avatar,n)
  end

  def each
    return enum_for(:each) unless block_given?
    tags.each { |tag| yield tag }
  end

private

  include ExternalDiskDir

  def path
    @avatar.path
  end

  def tags
    @tags ||= JSON.parse(dir.read('increments.json'))
  end

end
