
load('untitled.js');

var passCount = 0;
var failCount = 0;

function assertEqual(expected, actual) {
    if (expected !== actual) {
        print('FAILED:assertEqual(' +
            'expected=' + expected + ', ' + 
            'actual=' + actual + ')');
        failCount++;
    }
    else
        passCount++;
}

assertEqual(6 * 9, answer());

if (failCount === 0)
    print('All tests successful (' + passCount + ')');

