pun = require('../lib/pun.js').pun

$ = pun.$

foldl = (f, b) ->
	pun.match(
		[],      -> b
		$,  (xs) -> foldl(f, (f b, xs[0]))(xs[1..])
	)

foldr = (f, b) ->
	pun.match(
		[],      -> b
		$,  (xs) -> f xs[0], (foldr f, b)(xs[1..])
	)

sum = (a,b) -> a + b

console.log foldl(sum, 0)([1..10])
console.log foldr(sum, 0)([1..10])

###<<
55
55
>>###
