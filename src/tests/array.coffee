pun = require('../lib/pun.js').pun
$ = pun.$
___ = pun.splat

f = pun.match(
	[1,2,3],                             -> "onetwothree"
	[$, $('a'), $('b', Number)], (first) -> "#{first}, #{@a}, #{@b}"
)

console.log f([0,"lol",2])
console.log f([0,"lol",true])
console.log f([1,2,3])
console.log f([1,2,3,4])

###<<
0, lol, 2
undefined
onetwothree
undefined
>>###
