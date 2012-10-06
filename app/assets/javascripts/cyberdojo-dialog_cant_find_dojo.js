/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.dialog_cantFindDojo = function(title,id) {
    var yinYang = '<img alt="cyber-dojo" ' +
                       'border="0" ' +
                       'height="80" ' +
                       'src="/images/avatars/bw/cyber-dojo.png" ' +
                       'title="cyber-dojo" ' +
                       'width="80" />';
    var cantFindDojo = "" +
      '<div class="panel">' +
        '<table>' +
          '<tr>' +
            '<td>' +
              yinYang +
            '</td>' +
            '<td>' +
              '&nbsp;&nbsp;&nbsp;' +
            '</td>' +
            '<td>' +
              "I can't find a cyber-dojo with an id of" +
              '<h3>' + id + '</h3>' +
              "id's are always 10 characters long,<br/>" +
              "are case sensitive, and contain only<br/>" +
              "the digits 23456789 and letters ABCDEF" +
            '</td>' +
          '</tr>' +
        '</table>' +  
      '</div>';
    var width = 600;
    $cd.dialog(cantFindDojo, width, '!'+title);
  };

  return $cd;
})(cyberDojo || {}, $);
