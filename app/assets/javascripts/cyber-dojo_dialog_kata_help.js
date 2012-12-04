/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_kata_help = function(avatar) {    
    var imageSize = 57;
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
        +   '<img src="/images/traffic_light_' + color + '.png" width="22" height="65"/>'
        + '</td>';
    };
    var space = '&nbsp;';
    var spaces = Array.prototype.join.call({length:4}, space);

    var fakeTestButton = ''
      + '<div>'
      +   '<input type="submit" class="button" id="test" value="test"/>'
      + '</div>';

    var imageButtons = ''
      + '<table cellpadding="0" cellspacing="0">'
      +   '<tr>'
      +     '<td class="panel">'
      +        cd.makeTable(homePageImage, 'opens a' + br + 'home' + br + 'page')
      +     '</td>'
      +     '<td class="panel">'
      +        cd.makeTable(avatarImage, 'opens a'+ br + 'dashboard' + br +'page')
      +     '</td>'
      +     '<td class="panel">'            
      +       '<table>'
      +         '<tr>'
      +             tdTrafficLights()
      +           '<td>'
      +              'opens a' + br + 'revert' + br + 'dialog'
      +           '</td>'
      +         '</tr>'
      +       '</table>'
      +     '</td>'
      +   '</tr>'
      + '</table>';

    var testButton = ''
      + ''
      + '<div class="panel">'
      +   cd.makeTable(
            fakeTestButton,
            'results go to the',
            cd.fakeFilenameButton('<i>output</i>'),
            'file')
      + '</div>'
      + ''
      + '<div class="panel">'
      +   cd.makeTable(tdTrafficLights(),
            space + 'red means the tests ran but one or more failed' + br +
            space + 'amber means the tests could not be run' + br +
            space + 'green means the tests ran and all passed')
      + '</div>'
      + ''      
      + '<div class="panel">'
      +    cd.makeTable(cd.fakeFilenameButton('filename'), 'opens a file')
      + '</div>';

    var hotKeys = ''
      + ''
      + '<div class="panel">'
      +    space + '<b>alt-t</b> runs the <b><u>t</u></b>ests' + br 
      +    space + '<b>alt-f</b> cycles through the <b><u>f</u></b>iles'
      + '</div>';

    var improve = ''
      + ''
      + '<div class="panel">'
      +   space + 'think about improving, not finishing'
      + '</div>';

    var kataHelp = imageButtons + testButton + hotKeys + improve;

    cd.dialog(kataHelp, 540, '?');
  };

  return cd;
})(cyberDojo || {}, $);
