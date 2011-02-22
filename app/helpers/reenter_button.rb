
def reenter_button(dojo_name, avatar_name)
  "<form action='/kata/edit' target='_blank'>" +
    "<input type='hidden' name='dojo' id='dojo' value='#{dojo_name}'/>" +
    "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +
    "<input id='reenter_button'" + 
            "type='submit'" +
            "value='ReEnter'" + 
            "name='reenter' />" +
  "</form>"
end

