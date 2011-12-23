
var cyberDojo = (function($cd, $j) {

  $cd.help = function(avatar) {
    var imageSize = 40;
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
            'and displays the result in the output tab:' +
            '<ul>' +
              li + '<span class="failed">red - the tests ran but one or more failed</span></li>' +
              li + '<span class="error">amber - the tests could not be run</span></li>' +
              li + '<span class="passed">green - the tests ran and all passed</span></li>' +
            '</ul>' +
            'A traffic-light will also appear (at the top).<br/>' +
            'Clicking a traffic-light opens a diff-view of its files.' +
        '</li>' +
        li + 'Clicking the Post button (below the filenames) sends a message ' +
             'to everyone else in this dojo.' +
        '</li>' +
        li + avatarImageHtml + 
          'The avatar for this computer is the ' + avatar + '.<br/>' +
          'If you need to Resume-Coding please select the ' + avatar + '.' +
        '</li>' +
        '</ul>'; 
    
    var welcome = $j('<div>')
      .html(welcomeHtml)
      .dialog({
        autoOpen: false,
        width: 600,
        title: "Help",
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
