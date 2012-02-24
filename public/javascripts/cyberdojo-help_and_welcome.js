
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
      + '<img alt="' + avatar + '"'
      +     ' class="avatar_image"'
      +     ' width="' + imageSize + '"'
      +     ' height="' + imageSize + '"'
      +     ' style="float: left; padding: 2px;"'
      +     ' src="/images/avatars/' + avatar + '.jpg" title="' + avatar + '" />';
      
    var makeBigSpanLi = function(line) {
      return '<li><span style="font-size: 1.5em;">' + line + '</span></li>'
    };
    
    var welcomeHtml = ''    
      + '<div class="panel">'
      +   $cd.makeTable(avatarImage,
              'this is the '
            + '<span style="font-size: 1.8em;">' + avatar + "'s" + '</span>'
            + ' code<br/><br/>'
            + 'remember...'
            + '<ul>'
            +   makeBigSpanLi('you are not competing;<br/>you are practising')
            +   makeBigSpanLi("don't think about completing;<br/>think about improving")
            + '</ul>'
            )
      + '</div>'
      
      + '<div class="panel">'
      +   'click <input type="button" class="small button" value="help"/>'
      +   ' for help'
      + '</div>';
      
    var welcome = $j('<div>')
      .html('<div style="font-size: 1.0em;">' + welcomeHtml + '</div>')
      .dialog({
        autoOpen: false,
        width: 700,
        title: "<h1>welcome</h1>",
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    welcome.dialog('open');  
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
    
    var fakeFilenameButton = function(filename) {
      return ''
        + '<div class="mid_tone filename">'
        +   '<input type="radio"'
        +          'name="filename"'
        +          'value="filename"/>'
        +   '<label>' + filename + '</label>'
        + '</div>'
    };
    
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
            fakeFilenameButton('<i>output</i>'),
            'file')
      + '</div>'
      
      + '<div class="panel">'
      +   $cd.makeTable(tdTrafficLights(),
            '&nbsp;red means the tests ran but one or more failed' + br +
            '&nbsp;amber means the tests could not be run' + br +
            '&nbsp;green means the tests ran and all passed')
      + '</div>'
            
      + '<div class="panel">'
      +    $cd.makeTable(fakeFilenameButton('filename.ext'), 'opens a file for editing')
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
        title: "<h1>help</h1>",
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
})(cyberDojo || {}, $j);
