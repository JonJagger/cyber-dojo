
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

  $cd.welcome = function(avatar) {
    
    var imageSize = 200;
    var avatarImage = ''
      + '<table><tr><td>'
      + '<img alt="' + avatar + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />'
      + '</td></tr>'
      + '<tr><td>'
      + '<span style="font-size: 1.4em;">' + avatar + "'s" + '</span>  code'
      + '</td></tr></table>';
      
    var makeBigSpanLi = function(line) {
      return '<li><span style="font-size: 1.8em;">' + line + '</span></li>';
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
  
  $cd.h1 = function(title) {
    return '<h1>' + title + '</h1>';  
  };
  
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
      +     ' src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
        
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
      
      + '<div class="panel">'
      +   $cd.makeTable(
            '<input type="button" class="larger button" value="run-the-tests"/>',
            'results go to the',
            $cd.fakeFilenameButton('<i>output</i>'),
            'file')
      + '</div>'
      
      + '<div class="panel">'
      +   $cd.makeTable(tdTrafficLights(),
            '&nbsp;red means the tests ran but one or more failed' + br +
            '&nbsp;amber means the tests could not be run' + br +
            '&nbsp;green means the tests ran and all passed')
      + '</div>'
            
      + '<div class="panel">'
      +    $cd.makeTable($cd.fakeFilenameButton('filename'), 'opens a file')
      + '</div>'
      
      + '<div class="panel">'
      +    space + '<b>alt-t</b> runs the <b><u>t</u></b>ests' + br 
      +    space + '<b>alt-f</b> cycles through the <b><u>f</u></b>iles'
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

  $cd.fakeFilenameButton = function(filename) {
    return ''
      + '<table><tr><td>'
      + '<div class="filename" style="background:Cornsilk;color:#003C00;">'
      +   '<input type="radio"'
      +          'name="filename' + filename + '"'
      +          'checked="checked"'
      +          'value="filename"/>'
      +   '<label>' + '&nbsp;' + filename + '</label>'
      + '</div>'
      + '</td></tr></table>';
  };
  

  return $cd;
})(cyberDojo || {}, $j);
