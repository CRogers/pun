pun = require('../lib/pun').pun
$ = pun.$

List = pun.ADT
	Cons: ['value', 'next']
	Nil:  []


to = pun.match(
	[],      -> List.Nil() 
	$,  (xs) -> List.Cons xs[0], (to xs[1..])
)

from = pun.match(
	List.Nil(),               -> []
	List.Cons($, $),  (x, xs) -> [x].concat from(xs)
)


console.log (from to [1..10])

###<<
[ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 ]
>>###
