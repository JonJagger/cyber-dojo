/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.postTo = function(url, params, target) {
    
    if (params && params['id'] !== 'undefined') {
      url += '/' + params['id'];
    }
    
    var sep = '?';
    for (var key in params) {
        if (key !== 'id') {
          url += sep + key + '=' + params[key];
          sep = '&';
        }
    }
    
    var form = $j('<form>');
    form.attr('action', url);
    form.attr('method', 'POST');
    if (typeof(target) !== 'undefined') {
      form.attr('target', target);
    }

    form.appendTo(document.body);
    form.submit();
  };

  return $cd;
})(cyberDojo || {}, $);
