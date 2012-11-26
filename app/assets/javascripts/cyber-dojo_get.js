/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";
  
  
  
  cd.get = function(url, params, target) {
    //
    // cd.get('/kata/edit', { id: id, avatar: avatar_name  }, '_blank');
    //
    var key, sep = '?';
    var form = $('<form>');
    
    if (params && params.id !== 'undefined') {
      url += '/' + params.id;
    }
    
    for (key in params) {
        if (key !== 'id') {
          url += sep + key + '=' + encodeURIComponent(params[key]);
          sep = '&';
        }
    }
    
    form.attr('action', url);
    form.attr('method', 'GET');
    if (typeof(target) !== 'undefined') {
      form.attr('target', target);
    }

    form.appendTo(document.body);
    form.submit();
  };

  return cd;
})(cyberDojo || {}, $);
