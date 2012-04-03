stdtypes =

	List: pun.ADT
		Cons: ['value', 'next']
		Nil:  []
	
	BTree: pun.ADT
		Branch: ['left', 'right']
		Leaf:   ['value']

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
		List.Cons($, $), (x, xs) -> foldl f, (f z x), xs
	)


#
# END FUNCTIONS
#

stdfuncs =
	
	map: pun.uncurry map, 1, 1
	
	foldl: pun.uncurry foldl, 2, 1
	
	toList: toList

addExports stdfuncs
