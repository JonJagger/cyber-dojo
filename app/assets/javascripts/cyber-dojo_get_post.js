/*global $,cyberDojo*/

var cyberDojo = (function (cd, $) {
    "use strict";

    cd.postTo = function (url, params, target) {
        // cd.postTo('/kata/edit', { id: id, avatar: avatar_name  }, '_blank');
        cd.post_or_get('POST', url, params, target);
    };

    cd.get = function (url, params, target) {
        // cd.get('/kata/edit', { id: id, avatar: avatar_name  }, '_blank');
        cd.post_or_get('GET', url, params, target);
    };

    cd.post_or_get = function (method, url, params, target) {
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
        form.attr('method', method);
        if (typeof(target) !== 'undefined') {
            form.attr('target', target);
        }

        // append csrf-token to form. E.g.:
        //<input type="hidden" value="70qsxwZWWvUw29ByElrylrq+KpfcOvypJFWhM686Xcw=" name="authenticity_token">
        // the value of this token can be found in the header of the current page. E.g:
        // <meta name="csrf-token" content="70qsxwZWWvUw29ByElrylrq=">
        var token = $('meta[name="csrf-token"]').attr('content');
        var token_field = $('input');
        token_field.attr('name', 'authenticity_token').attr('value', token);
        form.append(token_field);

        form.appendTo(document.body);
        form.submit();
    };

    return cd;
})(cyberDojo || {}, $);

