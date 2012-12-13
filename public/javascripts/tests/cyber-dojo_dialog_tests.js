
var $cd = cyberDojo;

TestCase("cyber-dojo-dialog_tests", {  
  
  "test home page dialog buttons": function() {
    // Why do I have to fake cd.dialog() ?
    $cd.dialog = function(html, width, name) { };
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
  
  "test dialog_dashboard_tips": function() {
    $cd.dialog_dashboard_tips();    
  },
  
  "test dialog_kata_help": function() {
    $cd.dialog_kata_help();    
  },
  
  "test dialog_id": function() {
    title = 'id';
    info = { language: "Ruby" };
    $cd.dialog_id(title, info);    
  },
  
  "test dialog_cantFindDojo": function() {
    title = 'cant-find';
    id = '12345ABCDE';
    $cd.dialog_cantFindDojo(title, id);
  },
  
  "test dialog_fullDojo": function() {
    title = 'full';
    id = '12345ABCDE';
    $cd.dialog_fullDojo(title, id);
  },
  
  "test dialog_resumeCoding": function() {
    title = 'full';
    id = '12345ABCDE';
    $cd.dialog_resumeCoding(title, id);    
  },
  
  "test dialog_revert": function() {
    id = '12345ABCDE';
    avatarName = 'wolf';
    tag = "4";
    $cd.dialog_revert(id, avatarName, tag);
  },
  
});
