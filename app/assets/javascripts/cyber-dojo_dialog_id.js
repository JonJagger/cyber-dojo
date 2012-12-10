/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_id = function(title, info) {
    var panel = '<table>';
    $.each(info, function(key, value) {
      panel += '<tr>'
            +    '<td align="right">' + key + '</td>'
            +    '<td>:</td>'
            +    '<td align="left">' + value + '</td>'
            +  '</tr>';
    });
    panel += '</table>';    
    var id = $(cd.makeTable(cd.divPanel(panel)));    
    cd.dialog(id.html(), 450, title);    
  };
  
  return cd;
})(cyberDojo || {}, $);



