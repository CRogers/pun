bindIdent = {}
rawBindIdent = {}

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
	if pattern == pun._
		return true

	# see if it's a "raw param"
	if pattern.__rawBindIdent == rawBindIdent
		# see if the raw binding has an inner pattern
		if matchInnerPattern bindings, args, value, pattern
			args.push value
			return true
		else
			return false
			
	# see if patterns an ADT
	if pattern.__ADTIdent == ADTIdent
		# check value is an ADT
		if value.__ADTIdent != ADTIdent
			return false
		
		# check they are the same ADT
		if not (value instanceof pattern.constructor)
			return false
		
		# for each arg see if it matches
		for i in [0...pattern.__ADTArgs]
			if not matchPattern bindings, args, value["__ADT_#{i}"], pattern["__ADT_#{i}"]
				return false
		
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
				# check arrays are the same length
				if pattern.length != value.length
					return false
									
				# for each value in the array check that it matches the pattern	
				for i in [0...pattern.length]
					if not matchPattern bindings, args, value[i], pattern[i]
						return false
	
			# else we need to see if the value has all the properties of the pattern
			# and whether they equal eachother
			else
				for key, valuePattern of pattern
					# see if the value matches it's pattern
					if not matchPattern bindings, args, value[key], valuePattern
						return false
	
	return true


addExports(
	# wildcard operator
	_: {}
	wildcard: pun._
	
	# use as function arg operator
	$: (binding, innerPattern) -> 
		if typeof binding == 'string'
			{__bindIdent: bindIdent, binding, innerPattern}
		else
			{__rawBindIdent: rawBindIdent, innerPattern: binding}
	
	bind: pun.$
	
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
)

					
# add an ident to the raw $ so we can use it as a param
pun.$.__rawBindIdent = rawBindIdent
