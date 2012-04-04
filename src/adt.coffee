addExports(

	ADT: (ctors) ->
		retStruct = {}
		
		# get each ctor and params
		for ctor of ctors
			# fix for javascript's silly variable scoping
			(->
				params = ctors[ctor]
				# a unique object so we can identify when we used the 'newless' constructor
				newlessConstructorObj = {}
				
				Ctorf = (args...) ->
				
					# check to see if C has been called with `new`
					if not (this instanceof Ctorf)
						# if not pass arguments as single arg back to C
						return new Ctorf(newlessConstructorObj, args)
					
					# check if we got here from the line above, if so the args were passed in the second arg
					args = if (args[0] == newlessConstructorObj) then args[1] else args
					
					# for each param assign its value
					for i in [0...params.length]
						@[params[i]] = args[i]
					return
		
				# add a getter to alias __ADT_i to each param
				for i in [0...params.length]
					(->
						j = i
						param = params[j]
						Ctorf::__defineGetter__("__ADT_#{i}", -> @[param])
						# Add a static method to extract each param
						Ctorf[param] = (a) -> a[param]
					)()
				
				# add ADT ident to Ctorf function for use in pattern matching
				Ctorf::__defineGetter__('__ADTIdent', -> ADTIdent)
				Ctorf::__defineGetter__('__ADTArgs', -> params.length)
				
				# auto 'new' so new is not required for making type
				retStruct[ctor] = Ctorf
			)()
			
		return retStruct

)
