
var cyberDojo = (function($cd, $j) {

  $cd.help = function(avatar) {
    var imageSize = 50;
    var avatarImageHtml =
        '<img alt="' + avatar + '" class="floating_avatar_image"' +
        'width="' + imageSize + '"' +
        'height="' + imageSize + '"' +
        'src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
        
    var li = '<li style="margin: .5em 0;">';
    
    var welcomeHtml =
        '<ul>' +
        li + 'Clicking a filename (on the left) opens it in the editor tab.</li>' +
        li + 'Clicking the Run-Tests button (above the filenames) runs the tests ' +
            'and displays the result in the output tab in...' +
            '<ul>' +
              li + '<span class="failed">&nbsp;red if the tests ran but one or more failed&nbsp;</span></li>' +
              li + '<span class="error">&nbsp;amber if the tests could not be run&nbsp;</span></li>' +
              li + '<span class="passed">&nbsp;green if the tests ran and all passed&nbsp;</span></li>' +
            '</ul>' +
            'A traffic-light will also appear (at the top).<br/>' +
            'Clicking a traffic-light opens a diff-view of its files.' +
        '</li>' +
        li + 'Clicking the Post button (below the filenames) sends a message ' +
             'to everyone else in this dojo.' +
        '</li>' +
        li + avatarImageHtml + 
          'The avatar for this computer is the ' + avatar + '.<br/>' +
          'If you need to Resume-Coding (from the home page) please select the ' + avatar + '.' +
        '</li>' +
        '</ul>'; 
    
    var welcome = $j('<div>')
      .html(welcomeHtml)
      .dialog({
        autoOpen: false,
        width: 600,
        title: "help",
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
})(cyberDojo || {}, $j);
