
var $cd = cyberDojo;

TestCase("cyber-dojo-dialog_tests", {  
  
  "test home page dialog buttons": function() {
    $cd.dialog_about();
    $cd.dialog_basics();
    $cd.dialog_donations();
    $cd.dialog_faqs();
    $cd.dialog_feedback();
    $cd.dialog_links();
    $cd.dialog_source();
    $cd.dialog_tips();
    $cd.dialog_why();    
  },

  "test dialog_no_id": function() {
    $cd.dialog_noId();
  },
  
  "test dialog_cantFindDojo": function() {
    var id = '12345ABCDE';
    $cd.dialog_cantFindDojo(id);
  },

  "test dialog_dojoIsEmpty": function() {
    var id = '12345ABCDE';
    var empty = $cd.dialog_dojoIsEmpty(id);
    empty.dialog('option', 'buttons')['ok'].apply(empty);
  },
  
  "test dialog_dojoIsFull": function() {
    var id = '12345ABCDE';
    var full = $cd.dialog_dojoIsFull(id);
    full.dialog('option', 'buttons')['ok'].apply(full);
  },
  
  "test dialog_startCoding": function() {
    var id = '12345ABCDE';
    var avatarName = 'wolf';
    var html = '';
    var start = $cd.dialog_startCoding(id, avatarName, html);
    var actual = { };
    var wasPostTo = $cd.postTo;
    $cd.postTo = function(url, params, target) {
      actual.url = url;
      actual.params = params;
      actual.target = target;
    };
    start.dialog('option', 'buttons')['ok'].apply(start);
    $cd.postTo = wasPostTo;
    assertEquals('/kata/edit', actual.url);
    assertEquals({ id: id, avatar: avatarName }, actual.params);
    assertEquals('_blank', actual.target);
  },
  
  "test dialog_resumeCoding is cancelled": function() {
    var id = '1234512345';
    var html = '';
    var resume = $cd.dialog_resumeCoding(id, html);
    resume.dialog('option', 'buttons')['cancel'].apply(resume);    
  },

  "test dialog_resumeCoding avatar is clicked": function() {
    var id = '1234512345';
    var avatarName = 'wolf';
    var html = '';
    var resume = $cd.dialog_resumeCoding(id, html);
    var actual = { };
    var wasPostTo = $cd.postTo;    
    $cd.postTo = function(url, params, target) {
      actual.url = url;
      actual.params = params;
      actual.target = target;
    };
    $cd.resume(id, avatarName);    
    $cd.postTo = wasPostTo;
    assertEquals('/kata/edit', actual.url);
    assertEquals({ id: id, avatar: avatarName }, actual.params);
    assertEquals('_blank', actual.target);    
  },
  
  "test dialog_revert.createRevertDialog()": function() {
    var id = '1234512345';
    var avatarName = 'wolf';
    var tag = 15;
    $cd.dialog_revert(id, avatarName, tag);
    var data =  {
      visibleFiles: {
        'one': "one-content",
        'two': "two-content"
      },
      inc: {
        colour: 'red',
        revert_tag: '15',
        number: '44'
      }
    };
    $cd.dialog_revert.createRevertDialog(data);
  },
  
  //----------------------------

  "test dialog_dashboard_tips": function() {
    $cd.dialog_dashboard_tips();    
  },
  
  "test dialog_kata_help": function() {
    $cd.dialog_kata_help();    
  },
  
  "test dialog_id": function() {
    var title = '23ED346A7E';
    var info = { language: "Ruby" };
    $cd.dialog_id(title, info);    
  },
  
});
