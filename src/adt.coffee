addExports(

	ADT: (ctors) ->
		retStruct = {}
		
		# get each ctor and params
		for ctor of ctors
			# fix for javascript's silly variable scoping
			ctorf = (->
				params = ctors[ctor]
				
				ctorf = (args...) ->
					# for each param assign its value
					for i in [0...params.length]
						@[params[i]] = args[i]
					return
		
				# add a getter to alias __ADT_i to each param
				for i in [0...params.length]
					(->
						j = i
						ctorf::__defineGetter__("__ADT_#{i}", -> @[params[j]])
					)()
				
				return ctorf
			)()
		
			retStruct[ctor] = ctorf
			
		return retStruct

)
