(function() {
  var bindIdent, compareArrays, matchInnerPattern, matchPattern, out, rawBindIdent, seeIfBinding, subIdent;
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
  rawBindIdent = {};
  subIdent = {};
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
    var i, key, valuePattern, _ref;
    if (pattern === pun._) {
      return true;
    }
    if (pattern.__rawBindIdent === rawBindIdent) {
      args.push(value);
      return true;
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
          if (value.length !== pattern.length) {
            return false;
          }
          for (i = 0, _ref = value.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
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
  };
  out.pun.$.__rawBindIdent = rawBindIdent;
}).call(this);
