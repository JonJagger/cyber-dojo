/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {

  $cd.postTo = function(url, params, target) {
    var form = $j('<form>');
    form.attr('action', url);
    form.attr('method', 'POST');
    if (typeof(target) !== 'undefined') {
      form.attr('target', target);
    }

    var addParam = function(paramName, paramValue) {
      var input = $j('<input type="hidden">');
      input.attr({ id:     paramName,
                   name:   paramName,
                   value:  paramValue });
      form.append(input);
    };

    if (typeof(params) !== 'undefined') {
      for (var key in params) {
        addParam(key, params[key]);
      }
    }

    form.appendTo(document.body);
    form.submit();
  };

  return $cd;
})(cyberDojo || {}, $j);
