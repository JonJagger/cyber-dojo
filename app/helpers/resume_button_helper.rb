module ResumeButtonHelper

  def resume_button(dojo_name, avatar_name, size)
    "<form class='resume' action='/kata/edit'>" +
      "<input type='hidden' name='dojo_name' id='dojo_name' value='#{dojo_name}'/>" +
      "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +    
      "<input type='image'" +
              "class='avatar_image'" +
              "src='/images/avatars/#{avatar_name}.jpg'" +
              "title='Resume #{avatar_name.humanize}'" +
              "width='#{size}'" +
              "height='#{size}'" + "/>" +
    "</form>"    
  end
end
