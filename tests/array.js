(function() {
  var $, f, pun, ___;
  pun = require('../lib/pun.js').pun;
  $ = pun.$;
  ___ = pun.splat;
  f = pun.match([1, 2, 3], function() {
    return "onetwothree";
  }, [$, $('a'), $('b', Number)], function(first) {
    return "" + first + ", " + this.a + ", " + this.b;
  }, [$, $(___)], function(h, t) {
    return "Head: " + h + ", Tail: " + t;
  });
  console.log(f([0, "lol", 2]));
  console.log(f([0, "lol", true]));
  console.log(f([1, 2, 3]));
  console.log(f([1, 2, 3, 4]));
  console.log(f([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
  /*<<
  0, lol, 2
  undefined
  onetwothree
  undefined
  >>*/
}).call(this);
