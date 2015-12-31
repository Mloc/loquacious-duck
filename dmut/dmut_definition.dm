/dmut
	var/__structural = 1
	var/__name = null
	var/__fixture = null
	var/__suite = "Default"

	proc/run_test(liason)

	// should probably be a global library helper
	proc/__compare_lists(list/a, list/b)
		if(a.len != b.len) return 0
		if(a.len == 0) return 1
		for(var/i = 1; i <= a.len; i++)
			if(a[i] != b[i]) return 0
		return 1
	
	proc/fixture_setup()
	proc/fixture_destroy()
