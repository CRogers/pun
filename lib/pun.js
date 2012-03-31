(function() {
  var bindIdent, compareArrays, matchInnerPattern, matchPattern, out, seeIfBinding, sunIdent;
  compareArrays = function(a, b) {
    var i, _ref;
    if (a.length !== b.length) {
      return false;
    }
    for (i = 0, _ref = b.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      if (a[i] !== b[i]) {
        return false;
      }
    }
    return true;
  };
  bindIdent = {};
  sunIdent = {};
  seeIfBinding = function(bindings, value, pattern) {
    if ((pattern.__bindIdent != null) && pattern.__bindIdent === bindIdent) {
      bindings[pattern.binding] = value;
      return true;
    }
    return false;
  };
  matchInnerPattern = function(bindings, value, pattern) {
    if (pattern.innerPattern) {
      return matchPattern(bindings, pattern.innerPattern, value);
    } else {
      return true;
    }
  };
  matchPattern = function(bindings, value, pattern) {
    var key, valuePattern;
    if (seeIfBinding(bindings, value, pattern)) {
      return matchInnerPattern(bindings, value, pattern);
    }
    switch (typeof pattern) {
      case pun._:
        return true;
      case 'number':
      case 'string':
      case 'boolean':
      case null:
      case void 0:
        if (pattern !== value) {
          return false;
        }
        break;
      case 'function':
        if (!value instanceof pattern) {
          return false;
        }
        break;
      case 'object':
        if (Array.isArray(pattern)) {
          if (!compareArrays(pattern, value)) {
            return false;
          }
        } else {
          for (key in pattern) {
            valuePattern = pattern[key];
            if (seeIfBinding(bindings, value[key], valuePattern)) {
              return matchInnerPattern(bindings, value[key], valuePattern);
            }
            if (value[key] !== valuePattern) {
              return false;
            }
          }
        }
    }
    return true;
  };
  out = window || exports;
  out.pun = {
    _: {},
    $: function(binding, innerPattern) {
      return {
        __bindIdent: bindIdent,
        binding: binding,
        innerPattern: innerPattern
      };
    },
    s: function(subPattern) {
      return {
        __subIdent: subIdent,
        subPattern: subPattern
      };
    },
    match: function() {
      var args;
      args = arguments;
      return function(value) {
        var bindings, i, matchFunc, pattern, _ref;
        for (i = 0, _ref = args.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
          pattern = args[i++];
          matchFunc = args[i];
          bindings = {};
          if (matchPattern(bindings, value, pattern)) {
            return matchFunc.call(bindings);
          }
        }
      };
    }
  };
}).call(this);
