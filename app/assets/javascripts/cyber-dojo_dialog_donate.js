/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.invoiceMe = function() {
    var url = "mailto:jon@jaggersoft.com?subject=cyber-dojo donation - please invoice me";
    window.open(url, '_blank');
    return false;    
  };
  
  cd.dialog_donate = function() {
    
    var title = 'please donate';
    
    var donateButton = function() {
      return '' +
      '<form action="https://www.paypal.com/cgi-bin/webscr"' +
           ' method="post"' +
           ' id="donate-form"' +
           ' target="_blank">' +
      '<input type="hidden"' +
            ' name="cmd"' +
            ' value="_s-xclick">' +
      '<input type="hidden"' +
            ' name="hosted_button_id"' +
            ' value="7HAUYJCMFCS8C">' +
      '<input type="image"' +
            ' src="/images/donate.png"' +
            ' width="79"' +
            ' height="22"' +
            ' name="submit"' +
            ' alt="PayPal - The safe, easier way to pay online.">' +
      '<img alt=""' +
          ' src="https://www.paypalobjects.com/en_GB/i/scr/pixel.gif"' +
          ' width="1"' +
          ' height="1">' +
      '</form>';
    };
    
    var html = '' +
     '<div data-width="600">' +
     '<table>' +
       '<tr>' +
         '<td>' + donateButton() + '</td>' +
         '<td>' +
           "&nbsp;&nbsp;for an individual, I suggest donating $5+" +
         '</td>' + 
       '</tr>' +
       '<tr>' +
         '<td>' + donateButton() + '</td>' +
         '<td>' +
           "&nbsp;&nbsp;for a non-profit meetup, I suggest donating $15+" +
         '</td>' +
       '</tr>' +
       '<tr>' + 
         '<td>' + donateButton() + '</td>' +
         '<td>' +
           "&nbsp;&nbsp;for a commercial organization, I suggest donating $500+" +
         '</td>' + 
       '</tr>' +
      '</table>' +
      '<div>' +
    '<br/>if you need an invoice, please <a href=".." onclick="return cd.invoiceMe();">email me</a>';
        
        
    return cd.dialog(html,title,'close');
  };

  return cd;
})(cyberDojo || {}, $);
