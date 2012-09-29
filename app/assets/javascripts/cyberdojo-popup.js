/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.popup = function(name) {
    var grid = $j('<div>');
    grid.load('/dojo/' + name, { }, function() {
      $cd.dialogPopup(grid.html(), (name === 'why' ? 1100 : 850), name);
    });  
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.dialogPopup = function(html,width,name) {
    var div = $j('<div>')
      .html('<div style="font-size: 1.2em;">' + html + '</div>')    
      .dialog({
        autoOpen: false,
        width: width,
        title: '<h1>' + name + '</h1>',
        modal: true,
        buttons: {
          ok: function() {
            $j(this).dialog('close');
          }
        }
      });
    div.dialog('open');            
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  
  $cd.divPanel = function(content) {
    return '<div class="panel">' + content + '</div>';
  };
  
  return $cd;
})(cyberDojo || {}, $);



