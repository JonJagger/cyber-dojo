
function preRunTests() {
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :before => "preRunTests();",

  saveCurrentFile();
  selectFileInFileList('output');
  //TODO: there is a possible race here...
  //TODO: If, here, a different file is selected in the filename list
  //TODO: then this could overwrite the wrong file
  $j('#editor')
    .attr('class', 'waiting')
    .val('Running tests...');
  
  $j('#run_tests').fadeOut('slow', function() {   
      $j('#spinner').show();
  });
}

function postRunTests() { 
  // app/views/kata/edit.html.erb
  // form_remote_tag :url => {...}, 
  //                 :complete => "postRunTests();"

  selectFileInFileList('output');
  //TODO: there is a possible race here...
  //TODO: If, here, a different file is selected in the filename list
  //TODO: then this could overwrite the wrong file  
  $j('#editor').val($j('#output').val())
               .scrollTop(0)
               .scrollLeft(0);

  // new increment could affect layout
  refreshLineNumbering();

  $j('#spinner').fadeOut('slow', function() {
      $j('#run_tests').show();
  });
}

