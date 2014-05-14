
module FlagImageHelper

  def flag_image(name)
    image_tag "/images/countries/#{name}.png",
      :class => 'flag',
      :alt   => "#{name} flag",
      :title => "#{name}",
      :width => 50,
      :height => 30
  end

end
