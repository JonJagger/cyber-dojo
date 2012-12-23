
var $cd = cyberDojo;

TestCase("cyber-dojo_bind_line_numbers_tests", {
    
  "test bindAllLineNumbers()": function() {
    /*:DOC +=
      <div>
        <textarea id="file_content_for_cyberdojo.sh">fubar</textarea>
        <textarea id="file_content_for_instructions">snafu</textarea>
      </div>
    */
    $cd.bindAllLineNumbers();
    
    var instructions = $cd.fileContentFor('instructions');
    var simulate = function(eventName) {
      instructions.trigger({ type: eventName, which: "x".charCodeAt(0) });      
    };
    simulate('keydown');
    simulate('scroll');
    simulate('mousewheel');
    simulate('mousemove');
    simulate('mousedown');
    simulate('mouseup');
  },
  
});
