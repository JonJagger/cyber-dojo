/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.preRunTests = function() {
    $j('#run_tests_button').attr('disabled', true);
    
    $j('#rag').hide();
    $j('#tags_so_far').hide();
    $j('#spinner').show();
    $j('#tip').hide();
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  $cd.postRunTests = function() {
    $j('#tip').hide();
    $j('#spinner').hide();
    $j('#tags_so_far').show();
    $j('#rag').show();    
    $j('#run_tests_button').attr('disabled', false);
    // when the AJAX js replaces output shortcuts are lost
    // so need to rebind them    
    var output = $cd.fileContentFor('output');
    $cd.bindHotKeys(output);        
    $cd.loadFile('output');
  };

  return $cd;
})(cyberDojo || {}, $);


