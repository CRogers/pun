(function(){
	var out = (typeof process === 'undefined' || !process.versions)
	          ? this.window || {}
	          : exports;
	
	var pun = out.pun = {};
	
	var addExports = function(es) {
		for(var e in es)
			pun[e] = es[e];
	};
	
	ADTIdent = {};
	
(function() {
  var __slice = Array.prototype.slice;
  addExports({
    ADT: function(ctors) {
      var ctor, retStruct, _fn;
      retStruct = {};
      _fn = function() {
        var Ctorf, i, newlessConstructorObj, params, _fn2, _ref;
        params = ctors[ctor];
        newlessConstructorObj = {};
        Ctorf = function() {
          var args, i, _ref;
          args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
          if (!(this instanceof Ctorf)) {
            return new Ctorf(newlessConstructorObj, args);
          }
          args = args[0] === newlessConstructorObj ? args[1] : args;
          for (i = 0, _ref = params.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
            this[params[i]] = args[i];
          }
        };
        _fn2 = function() {
          var j;
          j = i;
          return Ctorf.prototype.__defineGetter__("__ADT_" + i, function() {
            return this[params[j]];
          });
        };
        for (i = 0, _ref = params.length; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
          _fn2();
        }
        Ctorf.prototype.__defineGetter__('__ADTIdent', function() {
          return ADTIdent;
        });
        Ctorf.prototype.__defineGetter__('__ADTArgs', function() {
          return params.length;
        });
        return retStruct[ctor] = Ctorf;
      };
      for (ctor in ctors) {
        _fn();
      }
      return retStruct;
    }
  });
}).call(this);
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
    uncurry: function() {
      var f, structure;
      f = arguments[0], structure = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
      return function() {
        var argPos, args, argsLeft, i, res, struct, _ref;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        argsLeft = args.length;
        res = f;
        for (i = 0, _ref = structure.length; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
          struct = structure[i];
          argPos = args.length - argsLeft;
          if (argsLeft === 0) {
            return res;
          } else if (argsLeft < struct) {
            return pun.uncurry.apply(this, [pun.curry.apply(this, [res].concat(args.slice(argPos))), struct - argsLeft].concat(structure.slice(i + 1)));
          } else {
            res = res.apply(this, args.slice(argPos, argPos + struct));
            argsLeft -= struct;
          }
        }
      };
    },
    autocurry: function(f, n) {
      return function() {
        var args;
        args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
        if (n - args.length <= 0) {
          return f.apply(this, args);
        } else {
          return pun.autocurry(pun.curry.apply(this, [f].concat(args)), n - args.length);
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
    var i, key, valuePattern, vtype, _ref, _ref2;
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
    if (pattern.__ADTIdent === ADTIdent) {
      if (value.__ADTIdent !== ADTIdent) {
        return false;
      }
      if (!(value instanceof pattern.constructor)) {
        return false;
      }
      for (i = 0, _ref = pattern.__ADTArgs; 0 <= _ref ? i < _ref : i > _ref; 0 <= _ref ? i++ : i--) {
        if (!matchPattern(bindings, args, value["__ADT_" + i], pattern["__ADT_" + i])) {
          return false;
        }
      }
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
          if (pattern.length !== value.length) {
            return false;
          }
          for (i = 0, _ref2 = pattern.length; 0 <= _ref2 ? i < _ref2 : i > _ref2; 0 <= _ref2 ? i++ : i--) {
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
(function() {
  var $, add, constant, cube, div, foldBT, foldT, foldl, foldl1, foldr, foldr1, id, map, mul, square, stdfuncs, stdtypes, sub, toArray, toList, unfold, unfoldL, _;
  stdtypes = {
    List: pun.ADT({
      Cons: ['value', 'next'],
      Nil: []
    }),
    BTree: pun.ADT({
      Branch: ['left', 'right'],
      Leaf: ['value']
    }),
    Tree: pun.ADT({
      Branch: ['branches'],
      Leaf: ['value']
    }),
    Maybe: pun.ADT({
      Just: ['value'],
      None: []
    }),
    Tuple: pun.ADT({
      T1: ['_1'],
      T2: ['_1', '_2'],
      T3: ['_1', '_2', '_3']
    })
  };
  addExports(stdtypes);
  addExports({
    copyStdtypes: function(obj) {
      var k, v, _results;
      _results = [];
      for (k in stdtypes) {
        v = stdtypes[k];
        _results.push(obj[k] = v);
      }
      return _results;
    },
    copyStdfuncs: function(obj) {
      var k, v, _results;
      _results = [];
      for (k in stdfuncs) {
        v = stdfuncs[k];
        _results.push(obj[k] = v);
      }
      return _results;
    },
    copyStdlib: function(obj) {
      pun.copyStdtypes(obj);
      return pun.copyStdfuncs(obj);
    }
  });
  $ = pun.$;
  _ = pun._;
  pun.copyStdtypes(this);
  id = function(x) {
    return x;
  };
  constant = function(a) {
    return function() {
      return a;
    };
  };
  add = function(a, b) {
    return a + b;
  };
  sub = function(a, b) {
    return a - b;
  };
  div = function(a, b) {
    return a / b;
  };
  mul = function(a, b) {
    return a * b;
  };
  square = function(a) {
    return a * a;
  };
  cube = function(a) {
    return a * a * a;
  };
  toList = pun.match([], function() {
    return List.Nil();
  }, $, function(xs) {
    return List.Cons(xs[0], toList(xs.slice(1)));
  });
  toArray = pun.match(List.Nil(), function() {
    return [];
  }, List.Cons($, $), function(x, xs) {
    return [x].concat(toArray(xs));
  });
  map = function(f) {
    return pun.match($(Array), function(a) {
      return a.map(f);
    }, List.Nil(), function() {
      return List.Nil();
    }, List.Cons($, $), function(x, xs) {
      return List.Cons(f(x), (map(f))(xs));
    }, BTree.Leaf($), function(v) {
      return BTree.Leaf(f(v));
    }, BTree.Branch($, $), function(l, r) {
      return BTree.Branch((map(f))(l), (map(f))(r));
    }, Tree.Leaf($), function(v) {
      return Tree.Leaf(f(v));
    }, Tree.Branch($), function(bs) {
      return Tree.Branch((map(map(f)))(bs));
    });
  };
  foldl = function(f, z) {
    return pun.match($(Array), function(a) {
      return ([z].concat(a)).reduce(f);
    }, List.Nil(), function() {
      return z;
    }, List.Cons($, $), function(x, xs) {
      return (foldl(f, f(z, x)))(xs);
    });
  };
  foldl1 = function(f, xs) {
    return foldl(f, xs[0], xs.slice(1));
  };
  foldr = function(f, z) {
    return pun.match($(Array), function(a) {
      return ([z].concat(a)).reduceRight(f);
    }, List.Nil(), function() {
      return z;
    }, List.Cons($, $), function(x, xs) {
      return f(x, (foldr(f, z))(xs));
    });
  };
  foldr1 = function(f, xs) {
    return foldr(f, xs[0], xs.slice(1));
  };
  foldBT = function(f, g) {
    return pun.match(BTree.Leaf($), function(v) {
      return f(v);
    }, BTree.Branch($, $), function(l, r) {
      return g((foldBT(f, g))(l), (foldBT(f, g))(r));
    });
  };
  foldT = function(f, g) {
    return pun.match(Tree.Leaf($), function(v) {
      return f(v);
    }, Tree.Branch($), function(bs) {
      return g((map(foldT(f, g)))(bs));
    });
  };
  unfold = function(f) {
    return function(z) {
      return pun.match(Maybe.None(), function() {
        return [];
      }, Maybe.Just(Tuple.T2($, $)), function(a, b) {
        return [a].concat((unfold(f))(b));
      })(f(z));
    };
  };
  unfoldL = function(f) {
    return function(z) {
      return pun.match(Maybe.None(), function() {
        return List.Nil();
      }, Maybe.Just(Tuple.T2($, $)), function(a, b) {
        return List.Cons(a, (unfoldL(f))(b));
      })(f(z));
    };
  };
  stdfuncs = {
    toList: toList,
    toArray: toList,
    id: id,
    constant: constant,
    add: pun.autocurry(add, 2),
    sub: pun.autocurry(sub, 2),
    div: pun.autocurry(div, 2),
    mul: pun.autocurry(mul, 2),
    square: square,
    cube: cube,
    map: pun.uncurry(map, 1, 1),
    foldl: pun.uncurry(foldl, 2, 1),
    foldl1: pun.autocurry(foldl1, 2),
    foldr: pun.uncurry(foldr, 2, 1),
    foldr1: pun.autocurry(foldr1, 2),
    foldBT: pun.uncurry(foldBT, 2, 1),
    foldT: pun.uncurry(foldT, 2, 1),
    unfold: pun.uncurry(unfold, 1, 1),
    unfoldL: pun.uncurry(unfoldL, 1, 1)
  };
  addExports(stdfuncs);
}).call(this);
}).call(this);
