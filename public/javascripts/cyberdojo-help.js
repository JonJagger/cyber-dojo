
var cyberDojo = (function($cd, $j) {

  $cd.help = function(avatar) {
    var imageSize = 50;
    var avatarImageHtml =
        '<img alt="' + avatar + '" class="avatar_image"' +
        'width="' + imageSize + '"' +
        'height="' + imageSize + '"' +
        'src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
        
    var br = '<br/>';
    
    var welcomeHtml = ''
      + '<div>'
        + '<input type="button" class="button" value="Run-Tests"/>'
        + ' to create a new traffic-light and display the'
        + ' test result in the output tab in '
        +   '<span class="failed">&nbsp;red&nbsp;</span> if the tests ran but one or more failed,</li>'
        +   '<span class="error">&nbsp;amber&nbsp;</span> if the tests could not be run, </li>'
        +   '<span class="passed">&nbsp;green&nbsp;</span> if the tests ran and all passed.</li>'
      + '</div>'
      
      + br
      
      + '<div>'
        + '<table>'
          + '<tr>'
            + '<td>'
              + '<div class="mid_tone filename">'
              +   '<input type="radio"'
              +          'name="filename"'
              +          'value="filename"/>'
              +   '<label>filename</label>'
              + '</div>'
            + '</td>'
            + '<td>to open a file for editing.</td>'
          + '</tr>'
        + '</table>'
      + '</div>'
              
      + br
      
      + '<div>'
        + '<table>'
        + '<tr>'
        + '<td>'
        +   '<div class="traffic_light">'
        +     '<span class="failed bulb"></span>'
        +     '<span class="off bulb"></span>'
        +     '<span class="off bulb"></span>'
        +   '</div>'
        + '</td>'
        + '<td>'
        +   '<div class="traffic_light">'
        +     '<span class="off bulb"></span>'
        +     '<span class="error bulb"></span>'
        +     '<span class="off bulb"></span>'
        +   '</div>'
        + '</td>'
        + '<td>'
        +   '<div class="traffic_light">'
        +     '<span class="off bulb"></span>'
        +     '<span class="off bulb"></span>'
        +     '<span class="passed bulb"></span>'
        +   '</div>'
        + '</td>'
        + '<td>to view a diff.</td>'
        + '</tr>'
        + '</table>'
      + '</div>'
      
      + br
      
      + '<div>'
        + '<input type="button" class="button" value="Post"/>'
        + ' to send a message to everyone.</li>'
      + '</div>'
        
      + br
      
      + '<div>'
        + '<img width="40" height="40" src="/images/avatars/cyber-dojo.png"/>'
        + ' to open a home page.'
      + '</div>'
      
      + br
        
      + '<div>'
      + avatarImageHtml
      + ' to open a dashboard page.'
      + '</div>'
      
      + br
      
      + 'If you need to '
      + '<input type="button" class="button" value="Resume-Coding"/>'
      + ' please remember that this computer is the ' + avatar + '.'
      + '';
    
    var welcome = $j('<div>')
      .html(welcomeHtml)
      .dialog({
        autoOpen: false,
        width: 600,
        title: "<h2>Click...</h2>",
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
