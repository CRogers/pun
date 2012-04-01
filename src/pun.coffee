compareArrays = (a,b) ->
	if a.length != b.length
		return false

	for i in [0...b.length]
		if (a[i] != b[i])
			return false

	return true

bindIdent = {}
rawBindIdent = {}
subIdent = {}

seeIfBinding = (bindings, args, value, pattern) ->
	# see if it's a value being bound - if so add it to the bindings
	if pattern.__bindIdent? && pattern.__bindIdent == bindIdent
		bindings[pattern.binding] = value
		return true
	
	return false

matchInnerPattern = (bindings, args, value, pattern) ->
	# if there is an inner pattern we must try and match that too
	if pattern.innerPattern
		return matchPattern bindings, args, value, pattern.innerPattern
	else
		return true

matchPattern = (bindings, args, value, pattern) ->

	# wildcard operator means we accept all
	if pattern == out.pun._
		return true

	# see if it's a "raw param"
	if pattern.__rawBindIdent == rawBindIdent
		args.push value
		return true
	
	if seeIfBinding bindings, args, value, pattern
		return matchInnerPattern bindings, args, value, pattern
	
	switch typeof pattern
		
		# if it is a number, array or boolean etc and perform equality
		when 'number', 'string', 'boolean', null, undefined
			return pattern == value

		# if it's a function, we see if its constructor is the same as the pattern 
		when 'function'
			vtype = typeof value
			# Deal with annoying literal cases - allow fall through to below statement 
			# to deal with new Number(4) etc
			switch pattern
				when Number
					return vtype == 'number' || value instanceof Number 
				when String
					return vtype == 'string' || value instanceof String
				when Boolean
					return vtype == 'boolean' || value instanceof Boolean
				else 
					return value instanceof pattern

		# else see other possibilties
		when 'object'
	
			# if array
			if Array.isArray pattern
				# for each value in the array check that it matches the pattern
				if(value.length != pattern.length)
					return false
					
				for i in [0...value.length]
					return matchPattern bindings, args, value[i], pattern[i]
	
			# else we need to see if the value has all the properties of the pattern
			# and whether they equal eachother
			else				
				for key, valuePattern of pattern
					# see if the value matches it's pattern
					return matchPattern bindings, args, value[key], valuePattern
	
	return true


# export to window if browser or exports if node
out = (this.windows || exports)

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
				matchArgs = []
				
				if matchPattern bindings, matchArgs, value, pattern
					return matchFunc.apply bindings, matchArgs

					
# add an ident to the raw $ so we can use it as a param
out.pun.$.__rawBindIdent = rawBindIdent
