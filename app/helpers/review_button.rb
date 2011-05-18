
def review_button(dojo_name, avatar_name)
  "<form action='/kata/review' target='_blank'>" +
    "<input type='hidden' name='dojo_name' id='dojo_name' value='#{dojo_name}'/>" +
    "<input type='hidden' name='avatar' id='avatar' value='#{avatar_name}' />" +
    "<input type='hidden' name='tag'    id='tag' value='0' />" +
    "<input class='button' +
            id='review_button'" + 
            "type='submit'" +
            "value='Review' />" + 
  "</form>"
end


