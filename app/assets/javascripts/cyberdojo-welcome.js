/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.welcome = function(avatar) {
    var imageSize = 200;
    var imageHtml =
        '<img alt="' + avatar + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
    var imageLabel = '<span style="font-size: 1.2em;">' + avatar + '</span>';
    var avatarImage =
        '<table>'
      +   '<tr><td>' + imageHtml + '</td></tr>'
      +   '<tr><td>' + imageLabel + '</td></tr>'
      + '</table>';
    var makeBigSpanLi = function(line) {
      return '<li><span style="font-size: 1.6em;">' + line + '</span></li>';
    };
    var welcomeHtml = ''    
      + '<div class="panel">'
      +   $cd.makeTable(avatarImage,
              '<ul>'
            +   makeBigSpanLi("think about improving<br/>not finishing<br/>")
            +   makeBigSpanLi('you are practising<br/>not competing<br/><br/>')
            + '</ul>'
            )
      + '</div>';
    var welcome = $j('<div>')
      .html('<div style="font-size: 1.0em;">' + welcomeHtml + '</div>')
      .dialog({
        autoOpen: false,
        width: 700,
        title: $cd.h1('welcome'),
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    welcome.dialog('open');  
  };
  
  return $cd;
})(cyberDojo || {}, $);
