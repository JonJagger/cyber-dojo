/*jsl:option explicit*/

var cyberDojo = (function($cd, $j) {
  
  $cd.dialog_id = function(info) {
    var fromDiff = false, panel = '<table>';
    $j.each(info, function(key,value) {
      if (key.indexOf('diff') != 0) {
        panel += '<tr>';
        panel +=   '<td align="right">' + key + '</td>';
        panel +=   '<td>:</td>';
        panel +=   '<td align="left">' + value + '</td>';
        panel += '</tr>';
      } else {
        fromDiff = true;
      }
    });
    panel += '</table>';
    
    var id = '';
    
    if (fromDiff) {
      var diffPanel = '';
      diffPanel += 'This cyber-dojo was forked from<br/>';
      diffPanel += '<a href="/diff/show/' + info['diff_id'] +
                    '?avatar=' + info['diff_avatar'] +
                    '&tag=' + info['diff_tag'] + '" ' +
                    'target="_blank">' +
                    info['diff_id'] + '-' + info['diff_avatar'] + '-' + info['diff_tag'] +
                    '</a>';
      id = $j($cd.makeTable($cd.divPanel(panel),
                            $cd.divPanel(diffPanel)));
      
    } else {
      id = $j($cd.makeTable($cd.divPanel(panel)));
    }
    
    $cd.dialog(id.html(), 450, 'config?');    
  };
  
  return $cd;
})(cyberDojo || {}, $);



