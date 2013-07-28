module TranslationHelper

  def translate_avatar(name)
    t "views.avatars.#{name}"
  end
  
  def translate_month_kata_created(kata)
    month_name = kata.created.strftime("%B")
    t "views.months.#{month_name}"
  end
  
end
