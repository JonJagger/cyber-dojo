/*jsl:option explicit*/

var cyberDojo = (function(cd, $) {

  cd.dialog_source = function() {

    var readmeUrl = 'https://github.com/JonJagger/cyberdojo/blob/master/readme.txt';
    var github =
      cd.divPanel(''
        + 'The cyber-dojo rails server is open source and '
        + '<a href="' + readmeUrl +'" '
        + ' target="_blank">'
        + 'lives on github'
        + '</a>. '
        + 'You will still need to install compilers for any languages (eg Java) '
        + 'you wish to practice.'
      );

    var dropBoxOvaUrl = 'http://dl.dropbox.com/u/11033193/CyberDojo/Turnkey-CyberDojo-20120515.ova'; 
    var ova =
      cd.divPanel(''
        + 'Alternatively, you can run your own cyber-dojo server using this 817MB '
        + '<a href="' + dropBoxOvaUrl + '">ova image file</a> '
        + 'which has all the language compilers installed. '
        + 'It was built from '
        + '<a href="http://www.turnkeylinux.org/" target="_blank">TurnKey Linux</a> '
        + 'and runs in '
        + '<a href="http://www.virtualbox.org/" target="_blank">VirtualBox</a>. '
        + "You'll want to read the "
        + '<a href="' + readmeUrl + '" target="_blank">'
        + 'github readme.txt'
        + '</a>.'
      );

    var turnKey =
      cd.divPanel(''
        + 'You can also build your own Turnkey Linux server from scratch using '
        + '<a href="http://jonjagger.blogspot.co.uk/2012/05/building-rails-3-turnkey-image.html" target="_blank">'
        + 'these instructions'
        + '</a>.'
      );

    var source = $(cd.makeTable(github,ova,turnKey));
      
    cd.dialog(source.html(), 550, 'source');
  };

  return cd;
})(cyberDojo || {}, $);



