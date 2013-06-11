/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_id = function(title, info) {
    var panel = '<table>';
    $.each(info, function(key, value) {
      panel += '<tr>'
            +    '<td class="align-right">' + key + '</td>'
            +    '<td>:</td>'
            +    '<td class="align-left">' + value + '</td>'
            +  '</tr>';
    });
    panel += '</table>';    
    var id = $(cd.makeTable(cd.divPanel(panel)));    
    return cd.dialog(id.html(), 450, title);    
  };
  
  return cd;
})(cyberDojo || {}, $);



