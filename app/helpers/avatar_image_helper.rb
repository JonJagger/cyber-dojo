
module AvatarImageHelper # mix-in

  module_function

  def avatar_image(name, size, title = name)
    name = name.downcase
    "<img src='/images/avatars/#{name.downcase}.jpg'" +
      " title='#{title.downcase}'" +
      " width='#{size}'" +
      " height='#{size}'" +
      " class='avatar-image'/>"
  end

end
