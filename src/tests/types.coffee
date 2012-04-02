pun = require('../lib/pun.js').pun
$ = pun.$

class Cat

f = pun.match(
	Number,  -> "Number"
	String,  -> "String"
	Boolean, -> "Boolean"
	Cat,      -> "Cat"
)

console.log f(1024)
console.log f("foobar")
console.log f(true)
console.log f(new Cat())

###<<
Number
String
Boolean
Cat
>>###
