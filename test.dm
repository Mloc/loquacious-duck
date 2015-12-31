/world/New()
	var/datum/dmut_manager/test_manager = new
	test_manager.run_tests()
	del(src)
