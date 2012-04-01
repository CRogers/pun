compareArrays = (a,b) ->
	if a.length != b.length
		return false

	for i in [0...b.length]
		if (a[i] != b[i])
			return false

	return true

bindIdent = {}
subIdent = {}

seeIfBinding = (bindings, value, pattern) ->
	# see if it's a value being bound - if so add it to the bindings
	if pattern.__bindIdent? && pattern.__bindIdent == bindIdent
		bindings[pattern.binding] = value
		return true
	
	return false

matchInnerPattern = (bindings, value, pattern) ->
	# if there is an inner pattern we must try and match that too
	if pattern.innerPattern
		return matchPattern bindings, value, pattern.innerPattern
	else
		return true

matchPattern = (bindings, value, pattern) ->

	if seeIfBinding bindings, value, pattern
		return matchInnerPattern bindings, value, pattern

	# wildcard operator means we accept all
	if pattern == pun._
		return true

	switch typeof pattern
		
		# if it is a number, array or boolean etc and perform equality
		when 'number', 'string', 'boolean', null, undefined
			if pattern != value
				return false

		# if it's a function, we want to use instanceof
		when 'function'
			if not value instanceof pattern
				return false

		# else see other possibilties
		when 'object'
	
			# if array
			if Array.isArray pattern
				# for each value in the array check that it matches the pattern
				if(value.length != pattern.length)
					return false
					
				for i in [0...value.length]
					if not matchPattern bindings, value[i], pattern[i]
						return false
	
			# else we need to see if the value has all the properties of the pattern
			# and whether they equal eachother
			else				
				for key, valuePattern of pattern
					# see if the value matches it's pattern
					if not matchPattern bindings, value[key], valuePattern
						return false
	
	return true


# export to window if browser or exports if node
out = window || exports

out.pun =

	# wildcard operator
	_: {}
	
	# use as function arg operator
	$: (binding, innerPattern) -> {__bindIdent: bindIdent, binding, innerPattern} 

	# allow subpatterns
	s: (subPattern) -> {__subIdent: subIdent, subPattern}

	match: ->		
		args = arguments
		(value) ->
			for i in [0...args.length]
				pattern = args[i++]
				matchFunc = args[i]
				
				bindings = {}				
				
				if matchPattern bindings, value, pattern
					return matchFunc.call bindings

					
					
