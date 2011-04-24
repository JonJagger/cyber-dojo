
def view_button(dojo_name, avatar_name)
  "<form action='/kata/view' target='_blank'>" +
    "<input type='hidden' name='dojo_name' id='dojo_name' value='#{dojo_name}'/>" +
    "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +
    "<input class='button' +
            id='view_button'" + 
            "type='submit'" +
            "value='View' />" + 
  "</form>"
end


