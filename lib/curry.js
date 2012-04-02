(function() {
  var __slice = Array.prototype.slice;
  addExports({
    curry: function() {
      var curryArgs, f;
      f = arguments[0], curryArgs = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        return f.apply(this, curryArgs.concat(args));
      };
    },
    autocurry: function(n, f) {
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (n - args.length <= 0) {
          return f.apply(this, args);
        } else {
          return pun.autocurry(n - args.length, pun.curry.apply(this, [f].concat(args)));
        }
      };
    }
  });
}).call(this);
