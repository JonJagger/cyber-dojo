
function postTo(url, params)
{
    var form = $j('<form>');
    form.attr('action', url);
    form.attr('method', 'POST');

    var addParam = function(paramName, paramValue) {
        var input = $j('<input type="hidden">');
        input.attr({ id:     paramName,
                     name:   paramName,
                     value:  paramValue });
        form.append(input);
    };

    for (var key in params) {
          addParam(key, params[key]);
    }

    form.appendTo(document.body);
    form.submit();
}
