stdtypes =

	List: pun.ADT
		Cons: ['value', 'next']
		Nil:  []
	
	BTree: pun.ADT
		Branch: ['left', 'right']
		Leaf:   ['value']
	
	Maybe: pun.ADT
		Just: ['value']
		None: []
	
	Tuple: pun.ADT
		T1: ['_1']
		T2: ['_1', '_2']
		T3: ['_1', '_2', '_3']
		

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

toList = pun.match(
	[],      -> List.Nil()
	$,  (xs) -> List.Cons(xs[0], toList xs[1..])
)

toArray = pun.match(
	List.Nil(),                -> []
	List.Cons($, $), (x, xs) -> [x].concat(toArray xs)
)

map = (f) ->
	pun.match(
		$(Array),              (a) -> a.map f
		List.Nil(),                -> List.Nil()
		List.Cons($, $),    (x,xs) -> List.Cons (f x), ((map f) xs)
		BTree.Branch($, $), (l, r) -> BTree.Branch ((map f) l), ((map f) r)
		BTree.Leaf($),         (v) -> f v
	)

foldl = (f, z) ->
	pun.match(
		$(Array),            (a) -> ([z].concat a).reduce f
		List.Nil(),              -> z
		List.Cons($, $), (x, xs) -> (foldl f, (f z, x))(xs)
	)

foldl1 = (f, xs) -> foldl(f, xs[0], xs[1..])

foldr = (f, z) ->
	pun.match(
		$(Array),            (a) -> ([z].concat a).reduceRight f
		List.Nil(),              -> z
		List.Cons($, $), (x, xs) -> f x, ((foldr f, z)(xs))
	)

foldr1 = (f, xs) -> foldr(f, xs[0], xs[1..])

foldBT = (f, g) ->
	pun.match(
		BTree.Leaf($),         (v) -> f v
		BTree.Branch($, $), (l, r) -> g ((foldBT f, g) l), ((foldBT f, g) r)
	)

unfold = (f) ->
	(z) ->
		pun.match(
			Maybe.None(),                      -> List.Nil()
			Maybe.Just(Tuple.T2($, $)), (a, b) -> List.Cons(a, (unfold f) b)
		)(f z)



#
# END FUNCTIONS
#

stdfuncs =
	
	toList: toList
	toArray: toArray
	
	map: pun.uncurry map, 1, 1
	
	foldl: pun.uncurry foldl, 2, 1
	foldl1: pun.autocurry foldl1, 2
	
	foldr: pun.uncurry foldr, 2, 1
	foldr1: pun.autocurry foldr1, 2
	
	foldBT: pun.uncurry foldBT, 2, 1
	
	unfold: pun.uncurry unfold, 1, 1
	
addExports stdfuncs
