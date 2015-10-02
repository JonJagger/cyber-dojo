
module DojoWorker # mix-in

  module_function

  def dojo_exists
    @dojo_exists ||= !katas[id].nil?
  end

  def started_avatar_names
    @started_avatar_names ||= avatars.each.collect { |avatar| avatar.name }
  end

  def empty
    started_avatar_names == []
  end

  def enter_dialog_html(avatar_name)
    @avatar_name = avatar_name
    bind('/app/views/dojo/enter_dialog.html.erb')
  end

  def full_dialog_html
    @all_avatar_names = Avatars.names
    bind('/app/views/dojo/full_dialog.html.erb')
  end

  def re_enter_dialog_html
    @id = id
    @started_avatar_names = started_avatar_names
    @all_avatar_names = Avatars.names
    bind('/app/views/dojo/re_enter_dialog.html.erb')
  end

  def bind(pathed_filename)
    filename = Rails.root.to_s + pathed_filename
    ERB.new(File.read(filename)).result(binding)
  end

end
