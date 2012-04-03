addExports(
	
	curry: (f, curryArgs...) ->
		(args...)-> 
			f.apply(this, curryArgs.concat args)
	
	uncurry: (f, structure...) ->
		(args...) ->
			argsLeft = args.length
			res = f
			for i in [0..structure.length]
				struct = structure[i]
				argPos = args.length-argsLeft
				if argsLeft == 0
					return res
				else if argsLeft < struct
					return pun.uncurry.apply this, [pun.curry args[argPos...], struct-argsLeft].concat(structure[i+1...])
				else
					res = res.apply this, args[argPos...argPos+struct]
				argsLeft -= 1
			return
				
	
	autocurry: (n, f) ->
		(args...) ->
			if n - args.length <= 0
				f.apply this, args
			else
				pun.autocurry (n - args.length), pun.curry.apply(this, [f].concat args)
)
