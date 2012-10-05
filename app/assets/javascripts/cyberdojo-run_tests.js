/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    $j('#test').attr('disabled', true);
    $j('.spinner').show();
    $j('#tip').hide();
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.postRunTests = function() {
    $j('#tip').hide();
    $j('.spinner').hide();
    $j('#test').attr('disabled', false);
    // when the AJAX js replaces output shortcuts
    // are lost so need to rebind them    
    var output = $cd.fileContentFor('output');
    $cd.bindHotKeys(output);        
    $cd.loadFile('output');
  };

  return $cd;
})(cyberDojo || {}, $);


