Pun
===

A tiny functional programming library for Javascript/Coffeescript.

Now [availiable on NPM](https://www.npmjs.org/package/pun)!

Currying
---

`pun.curry` allows you to partially apply some values to a function:

```coffeescript
f = (a,b,c,d) ->
	[a,b,c,d].join(', ')

fab = pun.curry f, 1, 2

fab(3,4)      # 1, 2, 3, 4
fab("c", "d") # 1, 2, c, d
```

`pun.autocurry` allows you to create functions which automatically curry when you apply arguments to them:

```coffeescript
# Using f from previous example
autof = pun.autocurry f

autofab = autof(1, 2)

autofab(3,4)      # 1, 2, 3, 4
autofab("c", "d") # 1, 2, c, d
```

Abstract Data Types
---

You can use ADTs like so:

```coffeescript
List = pun.ADT
	Cons: ['value', 'next']
	Nil:  []

l = List.Cons(1, List.Cons(2, List.Nil()))  # Linked list for [1,2]
l.value                                     # 1
l.next.value                                # 2
```

And can apply pattern matching!

Pattern Matching
---

Pun allows for complex pattern matching in javascript/coffeescript. Let's dive in with an example:

**Hello, factorial**

_Coffeescript_

```coffeescript
$ = pun.$

fac = pun.match(
    0, -> 1
    $, (n) -> n * fac (n-1)
)
```

_Javascript_

```javascript
var $ = pun.$

var fac = pun.match(
    0, function() { return 1 },            // Note required comma at end of line
    $, function(n){ return n * fac(n-1) }
)
```

This is equivalent to the Haskell:

```haskell
fac 0 = 1
fac n = n * fac (n-1)
```

`pun.match` takes pairs of arguments, the first being the `pattern` the second being the function applied if the pattern is matched. It will return `undefined` if there is no match.

**Basic Matching**

Numbers, strings, bools and undefined/nulls are all matched simply by equality:

```coffeescript
f = pun.match(
	110,      -> "one"
	"foobar", -> "two"
	true,     -> "three"
)

f(110)      # "one"
f("foobar") # "two"
f(true)     # "three"
```

**Wildcard**

The wild character `pun._` can be used to match any value:

```coffeescript
_ = pun._

f = pun.match(
    0, -> 0
    1, -> 1
    _, -> "Other"
)

f(0)           # 0
f(1)           # 1
f("foobarbaz") # "Other"
```

**Type Matching**

You can pass functions which will be interpreted as type constructors - this allows you to match your own "classes" or the builtin ones:

```coffeescript
class Cat

f = pun.match(
	Number,  -> "Number"
	String,  -> "String"
	Boolean, -> "Boolean"
	Cat,      -> "Cat"
)

f(1024)       # "Number"
f("foobar")   # "String"
f(true)       # "Boolean"
cf(new Cat()) # "Cat"
```

**Binding**

The `$` symbol can be used to 'bind' values so that you can use them in the matching function. You can use it without an argument and the bound value will be passed to match function as an argument, or with an argument of a pattern to match:

```coffeescript
$ = pun.$    # alias $ so we can use it more easily

f = pun.match(
    $(Number), (n) -> "Num: #{n}"
    $,         (a) -> "Got: #{a}"
)

f(0)    # "Num: 0"
f(true) # "Got: true"
f({})   # "Got: [object Object]"
```

Or you can supply it with a string `s` and it will be avaliable in `this.s`/`@s` of the match function:

```coffeescript
f = pun.match(
    $('a'), -> "Got: #{@a}"
)
```

Finally, you can bind to patterns:

```coffeescript
f = pun.match(
	$('a',Number), -> "Got: #{@a}"
)

f(1)     # "Got 1"
f(false) # undefined
```

**Arrays**

Arrays will be matched item by item and each element of the array is a pattern. The pattern array length and the value array length must be the same.

```coffeescript
$ = pun.$

f = pun.match(
	[1,2,3],                             -> "onetwothree"
	[$, $('a'), $('b', Number)], (first) -> "#{first}, #{@a}, #{@b}" 
)

f([0,"lol",2])    # "0, lol, 2"
f([0,"lol",true]) # undefined
f([1,2,3])        # "onetwothree"
f([1,2,3,4])      # undefined
```

**Objects**

Objects as a pattern will match each key and value. The value of each key/value pair is a pattern:

```coffeescript
$ = pun.$

f = pun.match(
	{a: 0, b: "lol"},          -> "One"
	{a: 0, b: $('n',Number)},  -> "Two #{@n}"
	{a: 0},                    -> "Three"
)

f({a:0})               # "Three"
f({a:0, b:"lol", c:1}) # "One"
f({a:0, b: 4})         # "Two 4"
```

**Abstract Data Types**

ADTs can also be matched:

```coffeescript
$ = pun.$

from = pun.match(
	List.Nil(),               -> []
	List.Cons($, $),  (x, xs) -> [x].concat from(xs)
)

from(List.Cons 1, List.Cons 2, List.Cons 3, List.Nil())  # [1,2,3]
```
