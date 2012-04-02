addExports(
	
	curry: (f, curryArgs...) ->
		(args...)-> 
			f.apply(this, curryArgs.concat args)
	
	autocurry: (n, f) ->
		(args...) ->
			if n - args.length <= 0
				f.apply this, args
			else
				pun.autocurry (n - args.length), pun.curry.apply(this, [f].concat args)
)
