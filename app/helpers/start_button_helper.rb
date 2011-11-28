module StartButtonHelper

  def start_button(dojo_name, avatar_name, size)
    "<form class='start' action='/start/chosen_avatar'>" +
      "<input type='hidden' name='dojo_name' id='dojo_name' value='#{dojo_name}'/>" +
      "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +    
      "<input type='image'" +
              "class='avatar_image'" +
              "src='/images/avatars/#{avatar_name}.jpg'" +
              "title='Start #{avatar_name.humanize}'" +
              "width='#{size}'" +
              "height='#{size}'" + "/>" +
    "</form>"    
  end
end
