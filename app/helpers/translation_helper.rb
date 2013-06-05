module TranslationHelper

  def translate_avatar name
    t "views.avatars.#{name}"
  end
end
