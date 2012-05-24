/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
    
  $cd.help = function(avatar) {    
    var imageSize = 70;
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
      +     ' src="/images/avatars/' + avatar + '.jpg"'
      +     ' title="' + avatar + '" />';
    var br = '<br/>';
    var tdTrafficLights = function() {
      return tdTrafficLight('red') + tdTrafficLight('amber') + tdTrafficLight('green');  
    };
    var tdTrafficLight = function(color) {
      return ''
        + '<td>'
        +   '<img src="/images/traffic-light-' + color + '.png" width="23" height="69"/>'
        + '</td>';
    };
    var space = '&nbsp;';
    var spaces = Array.prototype.join.call({length:4}, space);
    var welcomeHtml = ''      
      + '<table>'
      +   '<tr>'
      +     '<td class="panel">'
      +        $cd.makeTable(homePageImage, 'opens a' + br + 'home' + br + 'page')
      +     '</td>'
      +     '<td class="panel">'
      +        $cd.makeTable(avatarImage, 'opens a'+ br + 'dashboard' + br +'page')
      +     '</td>'
      +     '<td class="panel">'            
      +       '<table>'
      +         '<tr>'
      +             tdTrafficLights()
      +           '<td>'
      +              'opens a' + br + 'diff' + br + 'page'
      +           '</td>'
      +         '</tr>'
      +       '</table>'
      +     '</td>'
      +   '</tr>'
      + '</table>'
      + ''
      + '<div class="panel">'
      +   $cd.makeTable(
            '<input type="button" class="large button" value="run-the-tests"/>',
            'results go to the',
            $cd.fakeFilenameButton('<i>output</i>'),
            'file')
      + '</div>'
      + ''
      + '<div class="panel">'
      +   $cd.makeTable(tdTrafficLights(),
            space + 'red means the tests ran but one or more failed' + br +
            space + 'amber means the tests could not be run' + br +
            space + 'green means the tests ran and all passed')
      + '</div>'
      + ''      
      + '<div class="panel">'
      +    $cd.makeTable($cd.fakeFilenameButton('filename'), 'opens a file')
      + '</div>'
      + ''
      + '<div class="panel">'
      +    space + '<b>alt-t</b> runs the <b><u>t</u></b>ests' + br 
      +    space + '<b>alt-f</b> cycles through the <b><u>f</u></b>iles'
      + '</div>'
      + ''
      + '<div class="panel">'
      +   space + 'think about improving, not finishing' + br
      +   space + 'you are practising, not competing'
      + '</div>';
                          
    var help = $j('<div>')
      .html('<div style="font-size: 1.0em;">' + welcomeHtml + '</div>')
      .dialog({
        autoOpen: false,
        width: 575,
        title: $cd.h1('help'),
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    help.dialog('open');  
  };

  return $cd;
})(cyberDojo || {}, $);
