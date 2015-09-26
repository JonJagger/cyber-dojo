
# if I call this TranslationHelper
# then I am unable to access it from its tests!?

module MyTranslationHelper

  def translate_avatar(name)
    t "views.avatars.#{name}"
  end

end
