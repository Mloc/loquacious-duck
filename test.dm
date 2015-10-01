/world/New()
	for(var/p in typesof(/dmut))
		world.log << p
	var/datum/dmut_manager/test_manager = new
	test_manager.run_tests()
	del(src)
