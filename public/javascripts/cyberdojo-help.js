
var cyberDojo = (function($cd, $j) {

  $cd.help = function(avatar) {
    var imageSize = 50;
    var avatarImageHtml =
        '<img alt="' + avatar + '" class="avatar_image"' +
        'width="' + imageSize + '"' +
        'height="' + imageSize + '"' +
        'src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
        
    var br = '<br/>';
    
    var fakeFilenameButton = function(filename) {
      return ''
        + '<div class="mid_tone filename">'
        +   '<input type="radio"'
        +          'name="filename"'
        +          'value="filename"/>'
        +   '<label>' + filename + '</label>'
        + '</div>'
    };
    
    var tdTrafficLight = function(red,amber,green) {
      return ''
        + '<td>'
        +   '<div class="traffic_light">'
        +     '<span class="' + red   + ' bulb"></span>'
        +     '<span class="' + amber + ' bulb"></span>'
        +     '<span class="' + green + ' bulb"></span>'
        +   '</div>'
        + '</td>';
    };
    
    var space = '&nbsp;';
    
    var spaces = space + space + space + space;
    
    var coloured = function(property, color) {
      return  '<span class="' + property + '">' + space + color + space + '</span>';
    };
    
    var welcomeHtml = ''
      + '<div>'
        + '<table>'
          +  '<tr>'
            +  '<td>'
              + '<input type="button" class="large button" value="run-tests"/>'
            + '</td>'
            + '<td>'
              + ' displays the test result in the '
            + '</td>'
            + '<td>'
              + fakeFilenameButton('output')
            + '</td>'
            + '<td>'
              + ' file in '
            + '</td>'
          + '</tr>'
        + '</table>'
        + br + spaces + coloured('failed','red')
                      + ' - tests ran but one or more failed,'
        + br + spaces + coloured('error', 'amber')
                      + ' - tests could not be run,'
        + br + spaces + coloured('passed', 'green')
                      + ' - tests ran and all passed.'
      + '</div>'
      
      + br
      
      + '<div>'
        + '<table>'
          + '<tr>'
            + '<td>'
              + fakeFilenameButton('filename')
            + '</td>'
            + '<td>'
            +   'opens a file for editing.'
            + '</td>'
          + '</tr>'
        + '</table>'
      + '</div>'
              
      + br
      
      + '<div>'
        + '<table>'
          + '<tr>'
            + tdTrafficLight('failed', 'off', 'off')
            + tdTrafficLight('off', 'error', 'off')
            + tdTrafficLight('off', 'off', 'passed')
            + '<td>opens a diff page.</td>'
          + '</tr>'
        + '</table>'
      + '</div>'
      
      + br
      
      + '<div>'
        + '<input type="button" class="large button" value="post"/>'
        + ' sends a message to everyone.</li>'
      + '</div>'
        
      + br
      
      + '<div>'
        + '<img width="40" height="40" src="/images/avatars/cyber-dojo.png"/>'
        + ' opens a home page.'
      + '</div>'
      
      + br
        
      + '<div>'
      + avatarImageHtml
      + ' opens a dashboard page.'
      + '</div>'
      
      + br
      
      + 'If you need to '
      + '<input type="button" class="large button" value="resume-coding"/>'
      + ' please remember that this computer is the ' + avatar + '.'
      + '';
    
    var help = $j('<div>')
      .html(welcomeHtml)
      .dialog({
        autoOpen: false,
        width: 600,
        title: "<h2>help</h2>",
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
            // Ensure Hot-keys are live
            if ($cd.currentFilename() === 'output')
              $j('#output').focus();
            else
              $j('#editor').focus();
          }
        }
      });
    help.dialog('open');  
  };

  return $cd;
})(cyberDojo || {}, $j);
