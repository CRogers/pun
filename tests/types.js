(function() {
  var $, Cat, f, pun;
  pun = require('../lib/pun.js').pun;
  $ = pun.$;
  Cat = (function() {
    function Cat() {}
    return Cat;
  })();
  f = pun.match(Number, function() {
    return "Number";
  }, String, function() {
    return "String";
  }, Boolean, function() {
    return "Boolean";
  }, Cat, function() {
    return "Cat";
  });
  console.log(f(1024));
  console.log(f("foobar"));
  console.log(f(true));
  console.log(f(new Cat()));
  /*>>
  Number
  String
  Boolean
  Cat
  <<*/
}).call(this);