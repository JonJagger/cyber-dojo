/*global $,cyberDojo*/

var cyberDojo = (function(cd, $) {
  "use strict";

  cd.pieChart = function(nodes) {
    // Chart.js http://www.chartjs.org/docs/
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
        plural(  redCount,   'red') + ', ' +
        plural(amberCount, 'amber') + ', ' +
        plural(greenCount, 'green');
      var data = [
          { value:   redCount, color: "#f00" },
          { value: amberCount, color: "#fc3" },
          { value: greenCount, color: "#0f0" },
      ];
      var ctx = $(this)[0].getContext("2d");
      new Chart(ctx).Pie(data,options);
      $(this).closest('td').prop('title', title);
    });
  };

  return cd;
})(cyberDojo || {}, $);
