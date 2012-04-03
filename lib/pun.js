(function(){
	var out = (typeof process === 'undefined' || !process.versions)
	          ? this.window || {}
	          : exports;
	
	var pun = out.pun = {};
	
	var addExports = function(es) {
		for(var e in es)
			pun[e] = es[e];
	};
	
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
(function() {
  var bindIdent, matchInnerPattern, matchPattern, rawBindIdent, seeIfBinding;
  bindIdent = {};
  rawBindIdent = {};
  seeIfBinding = function(bindings, args, value, pattern) {
    if ((pattern.__bindIdent != null) && pattern.__bindIdent === bindIdent) {
      bindings[pattern.binding] = value;
      return true;
    }
    return false;
  };
  matchInnerPattern = function(bindings, args, value, pattern) {
    if (pattern.innerPattern) {
      return matchPattern(bindings, args, value, pattern.innerPattern);
    } else {
      return true;
    }
  };
  matchPattern = function(bindings, args, value, pattern) {
    var i, key, splatpos, valuePattern, vtype, _ref;
    if (pattern === pun._) {
      return true;
    }
    if (pattern.__rawBindIdent === rawBindIdent) {
      if (matchInnerPattern(bindings, args, value, pattern)) {
        args.push(value);
        return true;
      } else {
        return false;
      }
    }
    if (seeIfBinding(bindings, args, value, pattern)) {
      return matchInnerPattern(bindings, args, value, pattern);
    }
    switch (typeof pattern) {
      case 'number':
      case 'string':
      case 'boolean':
      case null:
      case void 0:
        return pattern === value;
      case 'function':
        vtype = typeof value;
        switch (pattern) {
          case Number:
            return vtype === 'number' || value instanceof Number;
          case String:
            return vtype === 'string' || value instanceof String;
          case Boolean:
            return vtype === 'boolean' || value instanceof Boolean;
          default:
            return value instanceof pattern;
        }
        break;
      case 'object':
        if (Array.isArray(pattern)) {
          splatpos = pattern.indexOf(pun.splat);
          if (splatpos === -1 && pattern.length !== value.length) {
            return false;
          }
          if (splatpos === -1) {
            splatpos = Infinity;
          }
          for (i = 0, _ref = pattern.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
            if (!matchPattern(bindings, args, value[i], pattern[i])) {
              return false;
            }
          }
        } else {
          for (key in pattern) {
            valuePattern = pattern[key];
            if (!matchPattern(bindings, args, value[key], valuePattern)) {
              return false;
            }
          }
        }
    }
    return true;
  };
  addExports({
    _: {},
    wildcard: pun._,
    $: function(binding, innerPattern) {
      if (typeof binding === 'string') {
        return {
          __bindIdent: bindIdent,
          binding: binding,
          innerPattern: innerPattern
        };
      } else {
        return {
          __rawBindIdent: rawBindIdent,
          innerPattern: binding
        };
      }
    },
    bind: pun.$,
    ___: {},
    splat: pun.___,
    match: function() {
      var args;
      args = arguments;
      return function(value) {
        var bindings, i, matchArgs, matchFunc, pattern, _ref;
        for (i = 0, _ref = args.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
          pattern = args[i++];
          matchFunc = args[i];
          bindings = {};
          matchArgs = [];
          if (matchPattern(bindings, matchArgs, value, pattern)) {
            return matchFunc.apply(bindings, matchArgs);
          }
        }
      };
    }
  });
  pun.$.__rawBindIdent = rawBindIdent;
}).call(this);
}).call(this);
