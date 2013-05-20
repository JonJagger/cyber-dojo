/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.dialog_links = function() {

    var blogUrl = 'http://jonjagger.blogspot.co.uk/'
    var company =
      cd.divPanel('' 
        + 'Jagger Software Limited '
        + '<a href="' + blogUrl + '" target="_blank">'
        + 'blog'
        + '</a>'
      );

    var thingsUrl = 'http://programmer.97things.oreilly.com/wiki/index.php/Contributions_Appearing_in_the_Book';
    var practiceUrl = 'http://jonjagger.blogspot.com/2011/02/deliberate-practice.html';
    var ninetySeven =
      cd.divPanel(''
        + '<a href="' + thingsUrl + '" target="_blank">'
        + '97 Things Every Programmer Should Know'
        + '</a>'
        + '<br/>'
        + '&nbsp;&nbsp;number 22: '
        + '<a href="' + practiceUrl + '" target="_blank">'
        + 'Do More Deliberate Practice'
        + '</a>'
      );

    var video =
      cd.divPanel(''
        + '<a href="http://vimeo.com/15104374" target="_blank">'
        + 'Video of me doing the Roman Numerals kata in Ruby'
        + '</a>'
      );

    var mapUrl = 'http://www.MasteringAgilePractice.com';
    var map = cd.divPanel('<a href="' + mapUrl + '" target="_blank">' + mapUrl + '</a>');
      
    var conferenceUrl = 'http://accu.org/index.php/conferences/accu_conference_2013';
    var accu =
      cd.divPanel(''
        + '<a href="' + conferenceUrl + '" target="_blank">'
        + '<img src="/images/accu_button.gif" '
        +       'style="float:left; border: 3px solid;" '
        +       'width="125" '
        +       'height="55" '
        +       'title="ACCU"/>'
        + '</a>'
        + '&nbsp;<a href="http://accu.org" target="_blank">accu</a> is a superb non-profit organisation<br/>'
        + '&nbsp;of programmers who <em>care</em> about<br/>'
        + '&nbsp;professionalism in programming.'
      );
      
    var links = $(cd.makeTable(company, ninetySeven, video, map, accu));
      
    return cd.dialog(links.html(), 550, 'links');
  };

  return cd;
})(cyberDojo || {}, $);



