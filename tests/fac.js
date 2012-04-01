(function() {
  var $, fac, i, pun;
  pun = require("../lib/pun.js").pun;
  $ = pun.$;
  fac = pun.match(0, function() {
    return 1;
  }, $, function(n) {
    return n * fac(n - 1);
  });
  for (i = 0; i <= 10; i++) {
    console.log(fac(i));
  }
  /*<<
  1
  1
  2
  6
  24
  120
  720
  5040
  40320
  362880
  3628800
  >>*/
}).call(this);
