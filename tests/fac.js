// Generated by CoffeeScript 1.6.3
(function() {
  var $, fac, i, pun, _i;

  pun = require("../lib/pun.js").pun;

  $ = pun.$;

  fac = pun.match(0, function() {
    return 1;
  }, $, function(n) {
    return n * fac(n - 1);
  });

  for (i = _i = 0; _i <= 10; i = ++_i) {
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
  >>
  */


}).call(this);
