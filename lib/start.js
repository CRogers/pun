(function(){
	var out = (typeof process === 'undefined' || !process.versions)
	          ? this.window || {}
	          : exports;
	
	var pun = out.pun = {};
	
	var addExports = function(es) {
		for(var e in es)
			pun[e] = es[e];
	};
	
	ADTIdent = {};
	
