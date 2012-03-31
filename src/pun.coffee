pun =

	compareArrays: (a,b) ->
		if a.length != b.length
			return false
	
		for i in [0...b.length]
			if a[i].compareArrays
				if !a[i].compareArrays(b[i]) 
					return false
				else 
					continue
			if (a[i] != b[i])
				return false
	
		return true


	match: ->		
		args = arguments		
		(value) ->
			0 && 0
			`outer: //`	
			for i in [0...args.length]
				pattern = args[i++]
				matchFunc = args[i]
		
				switch typeof pattern
				
					# if it is a number, array or boolean etc and perform equality
					when 'number', 'string', 'boolean', null, undefined
						if pattern != value
							continue
				
					# if it's a function, we want to use instanceof
					when 'function'
						if not value instanceof pattern
							continue
				
					# else see other possibilties
					when 'object'
					
						# if array
						if Array.isArray pattern
							if not pun.compareArrays pattern, value
								continue
					
						# else we need to see if the value has all the properties of the pattern
						# and whether they equal eachother
						else
							for k, v of pattern
								if value[k] != v
									`continue outer`
				
				# If there has been no continue up till here, then this pattern must work
				matchFunc()
				return

					
					
