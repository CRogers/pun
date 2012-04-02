pun = require('../lib/pun.js').pun
$ = pun.$

f = pun.match(
	{a: 0, b: "lol"},          -> "One"
	{a: 0, b: $('n',Number)},  -> "Two #{@n}"
	{a: 0},                    -> "Three"
)

console.log f({a:0})
console.log f({a:0, b:"lol", c:1})
console.log f({a:0, b: 4})

###<<
Three
One
Two 4
>>###
