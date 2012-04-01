(function() {
  var $, f, pun;
  pun = require('../lib/pun.js').pun;
  $ = pun.$;
  f = pun.match({
    a: 0,
    b: "lol"
  }, function() {
    return "One";
  }, {
    a: 0
  }, function() {
    return "Two";
  }, {
    a: 0,
    b: $('n', Number)
  }, function() {
    return "Three " + this.n;
  });
  console.log(f({
    a: 0
  }));
  console.log(f({
    a: 0,
    b: "lol",
    c: 1
  }));
  console.log(f({
    a: 0,
    b: 4
  }));
}).call(this);
