stdtypes =

	List: pun.ADT
		Cons: ['value', 'next']
		Nil:  []
	
	BTree: pun.ADT
		Branch: ['left', 'right']
		Leaf:   ['value']
	
	Tree: pun.ADT
		Branch: ['branches']
		Leaf:   ['value']
	
	Maybe: pun.ADT
		Just: ['value']
		None: []
	
	Either: pun.ADT
		Left:  ['value']
		Right: ['value']
	
	Tuple: pun.ADT
		T1: ['_1']
		T2: ['_1', '_2']
		T3: ['_1', '_2', '_3']

{List, BTree, Tree, Maybe, Either, Tuple} = stdtypes

addExports stdtypes

addExports
	copyStdtypes: (obj) ->
		for k, v of stdtypes
			obj[k] = v
	
	copyStdfuncs: (obj) ->
		for k, v of stdfuncs
			obj[k] = v
	
	copyStdlib: (obj) ->
		pun.copyStdtypes(obj)
		pun.copyStdfuncs(obj)


$ = pun.$
_ = pun._

pun.copyStdtypes this

#
# FUNCTIONS
#

id = (x) -> x

constant = (a) ->
	-> a

compose = (f, g) ->
	(x) -> f (g x)

add = (a, b) -> a + b
sub = (a, b) -> a - b
div = (a, b) -> a / b
mul = (a, b) -> a * b

square = (a) -> a * a
cube = (a) -> a * a * a

flip = (f, x, y) -> f y, x
boolnot = (a) -> !a
booland = (a, b) -> !!(a && b)
boolor = (a, b) -> !!(a || b)

equals = (a, b) -> a == b

either = (f, g) -> 
	pun.match(
		Either.Left($),  (x) -> f x
		Either.Right($), (x) -> g x
	)

untilP = (p, f, x) ->
	if p x then x
	else untilP p, f, (f x)


toList = pun.match(
	[],      -> List.Nil()
	$,  (xs) -> List.Cons(xs[0], toList xs[1..])
)

toArray = pun.match(
	List.Nil(),              -> []
	List.Cons($, $), (x, xs) -> [x].concat(toArray xs)
)

map = (f) ->
	pun.match(
		$(Array),              (a) -> a.map f
		List.Nil(),                -> List.Nil()
		List.Cons($, $),    (x,xs) -> List.Cons (f x), ((map f) xs)
		BTree.Leaf($),         (v) -> BTree.Leaf(f v)
		BTree.Branch($, $), (l, r) -> BTree.Branch ((map f) l), ((map f) r)
		Tree.Leaf($),          (v) -> Tree.Leaf(f v)
		Tree.Branch($),       (bs) -> Tree.Branch ((map (map f)) bs)
	)

filter = (p) ->
	case2 = (x, xs) ->
		if p x then [x].concat((filter p) xs)
		else ((filter p) xs)
		
	pun.match(
		[],              -> []
		$,          (xs) -> case2(xs[0], xs[1..])			
		List.Nil(),      -> List.Nil
		List.Cons($, $), case2			
	)

append = (a) ->	
	pun.match(
		$(Array),             (b) -> a.concat(b)
		List.Nil(),               -> a
		List.Cons(),      (x, xs) ->
	)

concat = (xss) -> foldr 

head = pun.match(
	$(Array),       (xs) -> xs[0]
	List.Cons($, _), (x) -> x
)

tail = pun.match(
	$(Array),        (xs) -> xs[1..]
	List.Cons(_, $), (xs) -> xs
)

last = pun.match(
	$(Array),                  (a) -> a[a.length-1]
	List.Cons($, List.Nil()), (x) -> x
	List.Cons(_, $),          (xs) -> last xs
)

init = pun.match(
	$(Array),
	List.Cons($, List.Nil()), (x) -> List.Nil()
	List.Cons($, $),       (x, xs) -> List.Cons(x, xs)
)

foldl = (f, z) ->
	pun.match(
		$(Array),            (a) -> ([z].concat a).reduce f
		List.Nil(),              -> z
		List.Cons($, $), (x, xs) -> (foldl f, (f z, x))(xs)
	)

foldl1 = (f, xs) -> foldl(f, xs[0]) xs[1..]

foldr = (f, z) ->
	pun.match(
		$(Array),            (a) -> ([z].concat a).reduceRight f
		List.Nil(),              -> z
		List.Cons($, $), (x, xs) -> f x, ((foldr f, z)(xs))
	)

foldr1 = (f, xs) -> foldr(f, xs[0]) xs[1..]

foldBT = (f, g) ->
	pun.match(
		BTree.Leaf($),         (v) -> f v
		BTree.Branch($, $), (l, r) -> g ((foldBT f, g) l), ((foldBT f, g) r)
	)

foldT = (f, g) ->
	pun.match(
		Tree.Leaf($),   (v) -> f v
		Tree.Branch($), (bs) -> g ((map (foldT f, g)) bs)
	)

unfold = (f) ->
	(z) ->
		pun.match(
			Maybe.None(),                      -> []
			Maybe.Just(Tuple.T2($, $)), (a, b) -> [a].concat ((unfold f) b)
		)(f z)

unfoldL = (f) ->
	(z) ->
		pun.match(
			Maybe.None(),                      -> List.Nil()
			Maybe.Just(Tuple.T2($, $)), (a, b) -> List.Cons(a, (unfoldL f) b)
		)(f z)

andL = foldr booland, true
orL = foldr boolor, false

all = (p) -> foldr ((a,b) -> booland(p a, p)), true
any = (p) -> foldr ((a,b) -> boolor(p a, b)), true


#
# END FUNCTIONS
#

stdfuncs =
	
	toList: toList
	toArray: toList
	
	id: id
	constant: constant
	compose: pun.autocurry compose, 2
	
	add: pun.autocurry add, 2
	sub: pun.autocurry sub, 2
	div: pun.autocurry div, 2
	mul: pun.autocurry mul, 2
	
	square: square
	cube: cube
	
	flip: pun.autocurry flip, 3
	
	boolnot: boolnot
	boolor: pun.autocurry boolor, 2
	booland: pun.autocurry booland, 2
	
	equals: pun.autocurry equals, 2
	
	either: pun.uncurry either, 2, 1
	
	untilP: pun.autocurry untilP, 3
	
	map: pun.uncurry map, 1, 1
	
	filter: pun.uncurry filter, 1, 1
	
	head: head
	tail: tail
	last: last
	init: init
	
	foldl: pun.uncurry foldl, 2, 1
	foldl1: pun.autocurry foldl1, 2
	
	foldr: pun.uncurry foldr, 2, 1
	foldr1: pun.autocurry foldr1, 2
	
	foldBT: pun.uncurry foldBT, 2, 1
	foldT: pun.uncurry foldT, 2, 1
	
	unfold: pun.uncurry unfold, 1, 1
	unfoldL: pun.uncurry unfoldL, 1, 1
	
	all: pun.uncurry all, 1, 1
	any: pun.uncurry any, 1, 1
	
addExports stdfuncs
