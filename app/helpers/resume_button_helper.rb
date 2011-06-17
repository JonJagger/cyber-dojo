module ResumeButtonHelper

  def resume_button(dojo_name, avatar_name)
    "<form action='/kata/edit' target='_blank'>" +
      "<input type='hidden' name='dojo_name' id='dojo_name' value='#{dojo_name}'/>" +
      "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +
      "<input class='button'" +
             "id='resume_button'" + 
             "type='submit'" +
             "value='Resume' />" + 
    "</form>"
  end

end
