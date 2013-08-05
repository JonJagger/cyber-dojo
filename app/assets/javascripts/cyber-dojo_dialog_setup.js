/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
      
  var rnd = function(list) {
    return Math.floor(Math.random() * list.size());
  };
  
  var setup_open = function() {
    var languages = $('[name=language]');
    var randomLanguage = rnd(languages);
    var previousLanguage = $(languages[randomLanguage]);
  
    var exercises = $('[name=exercise]');
    var randomExercise = rnd(exercises);   
    var previousExercise = $(exercises[randomExercise]);

    languages.each(function(index) {
      var node = $(this);
      node.parent().click(function() {
        cd.radioEntrySwitch(previousLanguage, node);
        previousLanguage = node;
      });
    });
      
    exercises.each(function(index) {
      var instructions = $('#instructions_' + index).val();
      var node = $(this);
      node.parent().click(function() {
        cd.radioEntrySwitch(previousExercise, node);
        previousExercise = node;
        $('#instructions').val(instructions);      
      });
    });
    
    $('input[type=radio]').hide();
    // Ideally this would not only click the randomly
    // selected element but would also scroll it into
    // view if necessary.
    $('#language_' + randomLanguage).parent().click();
    $('#exercise_' + randomExercise).parent().click();    
  };
  
  var i18nButtons = function(ok, cancel) {
    var buttons = { };
    buttons[ok] = function() {
      $.get('/setup/ok', {
        exercise: $('input[name="exercise"]:checked').val(),
        language: $('input[name="language"]:checked').val()
      }, function(dojo) {
        $('#kata_id_input').val(dojo.id);
      });
      // It's important to close the dialog and also remove the
      // hosting div from the dom. If I don't do this then each
      // time the setup page is retrieved from the server I get
      // an additional list of languages and an additional list
      // of exercises.
      $(this).dialog('destroy').remove();
    };
    buttons[cancel] = function() {
      $(this).dialog('destroy').remove();
    };
    return buttons;
  };
  
  cd.dialog_setup = function(html, title, ok, cancel) {
    return $('<div class="dialog" id="setup_dialog">' + html + '</div>')    
      .dialog({
        modal: true,
        autoOpen: false,
        // allowing escape to close causes the instructions to not be loaded
        // the next time setup is pressed. Don't know why.
        closeOnEscape: false,
        open: function() { setup_open(); },
        width: 1100,
        height: 700,
        title: cd.dialogTitle(title),
        buttons: i18nButtons(ok, cancel)
      });
  };

  return cd;
})(cyberDojo || {}, $);
