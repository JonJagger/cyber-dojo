/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.pieChart = function(nodes) {
    var options = {
      segmentShowStroke : false,
      animation: false
    };
    var plural = function(n,word) {
      return "" + n + " " + word + (n == 1 ? "" : "s");
    }
    nodes.each(function() {
      var   redCount = $(this).data('red-count');
      var amberCount = $(this).data('amber-count');
      var greenCount = $(this).data('green-count');
      var title = "" +
        plural(redCount,'red') + ', ' +
        plural(amberCount, 'amber') + ', ' +
        plural(greenCount, 'green');
      var data = [
          { value:   redCount, color: "#ff0000" },
          { value: amberCount, color: "#ffcc33" },
          { value: greenCount, color: "#00ff00" },
      ];
      var ctx = $(this)[0].getContext("2d");
      new Chart(ctx).Pie(data,options);
      $(this).closest('td').prop('title', title);
    });
  };

  return cd;
})(cyberDojo || {}, $);
