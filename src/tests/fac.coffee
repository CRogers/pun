pun = require("../lib/pun.js").pun

$ = pun.$

fac = pun.match(
	0, -> 1
	$, (n) -> n * fac (n-1)
)

for i in [0..10]
	console.log fac i

###<<
1
1
2
6
24
120
720
5040
40320
362880
3628800
>>###
