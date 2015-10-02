
module LogoImageHelper # mix-in

  module_function

  def logo_image(size, title)
    "<img src='/images/avatars/cyber-dojo.png'" +
      " alt='cyber-dojo yin-yang logo'" +
      " title='#{title}'" +
      " width='#{size}'" +
      " height='#{size}'/>"
  end

  def home_page_logo(size = 68)
    "<img src='/images/home_page_logo.png'" +
      " alt='cyber-dojo'" +
      " title='cyber-dojo'" +
      " width='#{size}'" +
      " height='#{size}'/>"
  end

end
