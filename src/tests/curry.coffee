pun = require('../lib/pun').pun

f = (a,b,c,d) ->
	[a,b,c,d].join(', ')

fab = pun.curry f, 1, 2

console.log fab(3,4)
console.log fab("c", "d")


autof = pun.autocurry f, 4


autofab = f(1, 2)

console.log autofab(3,4)
console.log autofab("c", "d")

###<<
1, 2, 3, 4
1, 2, c, d
1, 2, 3, 4
1, 2, c, d
>>###
