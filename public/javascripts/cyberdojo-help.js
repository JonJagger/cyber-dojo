
var cyberDojo = (function($cd, $j) {
  
  $cd.makeTable = function() {
    var makeTd = function(arg) {
      return '<td>' + arg + '</td>';
    };    
    var i;
    var table = '<table><tr>';
    for (i = 0; i < arguments.length; i += 1) {
      table += makeTd(arguments[i]);
    }
    table += '</tr></table>';
    return table;
  };
  

  $cd.whoAmI = function(avatar) {
    
    var imageSize = 300;
    var avatarImage = ''
      + '<img alt="' + avatar + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
      
    var welcomeHtml = ''
      + '<div class="panel">'
      +   $cd.makeTable(avatarImage,
            'This is the '
            + '<span style="font-size: 2.0em;">' + avatar + '</span>'
            + ' computer.')
      + '</div>';
    
    var whoAmI = $j('<div>')
      .html('<div style="font-size: 1.0em;">' + welcomeHtml + '</div>')
      .dialog({
        autoOpen: false,
        width: 475,
        title: "<h2>Welcome</h2>",
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    whoAmI.dialog('open');  
  };
  
  $cd.help = function(avatar) {
    
    var imageSize = 50;

    var homePageImage = ''    
      + '<img'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/cyber-dojo.png"/>';
    
    var avatarImage = ''
      + '<img alt="' + avatar + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
        
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
    var spaces = Array.prototype.join.call({length:4}, space);
    
    var coloured = function(property, color) {
      return  '<span class="' + property + '">' + space + color + space + '</span>';
    };
    
    var welcomeHtml = ''      
      + '<table>'
      +   '<tr>'
      +     '<td class="panel">'
      +        $cd.makeTable(homePageImage, 'opens a' + br + 'home' + br + 'page')
      +     '</td>'
      +     '<td class="panel">'
      +         $cd.makeTable(avatarImage, 'opens a'+ br + 'dashboard' + br +'page')
      +     '</td>'      
      +     '<td class="panel">'            
      +       '<table>'
      +         '<tr>'
      +             tdTrafficLight('failed', 'off', 'off')
      +             tdTrafficLight('off', 'error', 'off')
      +             tdTrafficLight('off', 'off', 'passed')
      +           '<td>'
      +              'opens a' + br + 'diff' + br + 'page'
      +           '</td>'
      +         '</tr>'
      +       '</table>'
      +     '</td>'
      +   '</tr>'
      + '</table>'
      
      + '<div class="panel">'
      +   $cd.makeTable(
            '<input type="button" class="large button" value="run-tests"/>',
            'results go to the',
            fakeFilenameButton('<i>output</i>'),
            'file')
        + '</div>'
        
      + '<div class="panel">'
      +   $cd.makeTable(tdTrafficLight('failed', 'error', 'passed'),
            ' red means the tests ran but one or more failed' + br +
            ' amber means the tests could not be run' + br +
            ' green means the tests ran and all passed')
      + '</div>'
            
      + '<div class="panel">'
      +    $cd.makeTable(fakeFilenameButton('filename.ext'), 'opens a file for editing')
      + '</div>'
              
      + '<div class="panel">'
        + '<input type="button" class="large button" value="post"/>'
        + ' sends a message to everyone</li>'
      + '</div>'
                    
      + '<div class="panel">'
      +   'If you need to '
      +   '<input type="button" class="large button" value="resume-coding"/>'
      +   ' please' + br
      +   'remember - this is the ' + avatar + ' computer.'
      + '</div>';
      
    var help = $j('<div>')
      .html('<div style="font-size: 1.0em;">' + welcomeHtml + '</div>')
      .dialog({
        autoOpen: false,
        width: 475,
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
