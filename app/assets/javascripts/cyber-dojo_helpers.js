/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.id = function(name) {
    return $('[id="' + name + '"]');
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.inArray = function(find, array) {
    return $.inArray(find, array) !== -1;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.showReviewUrl = function(id, avatarName, wasTag, nowTag) {
    return '/review/show/' + id + '?avatar=' + avatarName +
                                  '&was_tag=' + wasTag +
                                  '&now_tag=' + nowTag;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.homePageUrl = function(id) {
    return '/dojo/index/' + id;
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  cd.td = function(html) {
 	  return '<td>' + html + '</td>';
  };

  //- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  return cd;

})(cyberDojo || {}, $);
