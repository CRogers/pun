addExports(
	
	curry: (f, curryArgs...) ->
		(args...)-> 
			f.apply(this, curryArgs.concat args)
	
	uncurry: (f, structure...) ->
		(args...) ->
			argsLeft = args.length
			res = f
			# for each group of args in f(a,b)(c,d)(e) we run the as many args as we can,
			# catching new functions each time they are return and using more args on them
			for i in [0..structure.length]
				struct = structure[i]
				argPos = args.length-argsLeft
				
				# if we have used all the args just return the result
				if argsLeft == 0
					return res
				# if we have run out of args, partial apply the args we got
				else if argsLeft < struct
					return pun.uncurry.apply this, [(pun.curry.apply this, [res].concat args[argPos...]), struct-argsLeft].concat(structure[i+1...])
				# get the next function
				else
					res = res.apply this, args[argPos...argPos+struct]
					argsLeft -= struct
			return
				
	
	autocurry: (f, n) ->
		(args...) ->
			if n - args.length <= 0
				f.apply this, args
			else
				pun.autocurry pun.curry.apply(this, [f].concat args), (n - args.length)
)
