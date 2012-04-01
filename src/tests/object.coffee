pun = require('../lib/pun.js').pun
$ = pun.$

f = pun.match(
	{a: 0, b: "lol"},          -> "One"
	{a: 0},                    -> "Two"
	{a: 0, b: $('n',Number)},  -> "Three #{@n}"
)

console.log f({a:0})               # "Two"
console.log f({a:0, b:"lol", c:1}) # "One"
console.log f({a:0, b: 4})         # "Three 4"
