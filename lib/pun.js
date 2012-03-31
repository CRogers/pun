var pun;
pun = {
  compareArrays: function(a, b) {
    var i, _ref;
    if (a.length !== b.length) {
      return false;
    }
    for (i = 0, _ref = b.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
      if (a[i].compareArrays) {
        if (!a[i].compareArrays(b[i])) {
          return false;
        } else {
          continue;
        }
      }
      if (a[i] !== b[i]) {
        return false;
      }
    }
    return true;
  },
  match: function() {
    var args;
    args = arguments;
    return function(value) {
      var i, k, matchFunc, pattern, v, _ref;
      0 && 0;
      outer: //;
      for (i = 0, _ref = args.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        pattern = args[i++];
        matchFunc = args[i];
        switch (typeof pattern) {
          case 'number':
          case 'string':
          case 'boolean':
          case null:
          case void 0:
            if (pattern !== value) {
              continue;
            }
            break;
          case 'function':
            if (!value instanceof pattern) {
              continue;
            }
            break;
          case 'object':
            if (Array.isArray(pattern)) {
              if (!pun.compareArrays(pattern, value)) {
                continue;
              }
            } else {
              for (k in pattern) {
                v = pattern[k];
                if (value[k] !== v) {
                  continue outer;
                }
              }
            }
        }
        matchFunc();
        return;
      }
    };
  }
};