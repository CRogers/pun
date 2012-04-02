(function() {
  var $, f, pun;
  pun = require('../lib/pun.js').pun;
  $ = pun.$;
  f = pun.match([1, 2, 3], function() {
    return "onetwothree";
  }, [$, $('a'), $('b', Number)], function(first) {
    return "" + first + ", " + this.a + ", " + this.b;
  });
  console.log(f([0, "lol", 2]));
  console.log(f([0, "lol", true]));
  console.log(f([1, 2, 3]));
  console.log(f([1, 2, 3, 4]));
  /*<<
  0, lol, 2
  undefined
  onetwothree
  undefined
  >>*/
}).call(this);
