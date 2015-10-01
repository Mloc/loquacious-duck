// test manager datum
/datum/dmut_manager
	var/list/tests_by_suite
	var/total_tests

/datum/dmut_manager/New()
	populate_tests()

/datum/dmut_manager/proc/dmut_log(msg)
	world.log << msg

/datum/dmut_manager/proc/populate_tests()
	tests_by_suite = list()
	total_tests = 0

	var/dmut/test
	for(var/p in typesof(/dmut))
		test = p

		if(initial(test.__structural))
			continue

		var/suite = initial(test.__suite)
		var/suite_tests = tests_by_suite[suite]

		if(!suite_tests)
			suite_tests = list()
			tests_by_suite[suite] = suite_tests
	
		suite_tests += test
		total_tests++
	
	dmut_log("Populated [total_tests] test\s from [tests_by_suite.len] suite\s.")

/datum/dmut_manager/proc/test_suite(suite)
	var/list/tests = tests_by_suite[suite]

	var/fail_count = 0
	var/exception/liason = new

	var/dmut/test
	for(var/p in tests)
		test = new p

		var/ret_val = null
		try
			if(test.__fixture)
				test.fixture_setup()

			ret_val = test.run_test(liason)

			if(test.__fixture)
				test.fixture_destroy()
		catch(var/exception/e)
			ret_val = 1
			liason.name = "unhandled exception '[e.type] ([e.name])'"
			liason.file = e.file
			liason.line = e.line

		if(ret_val)
			fail_count++
			if(0) {CRASH("what?")} //create a new scope and discard to work around a really fucking weird byond bug
			dmut_log("[liason.file]:[liason.line]: error: Test failure in [test.__name]: [liason.name]")

	if(fail_count == 0)
		dmut_log("[suite]: PASSING ([tests.len] test\s passed)")
	else
		dmut_log("[suite]: FAILING ([fail_count] out of [tests.len] tests failed)")

	return fail_count

/datum/dmut_manager/proc/run_tests()
	for(var/suite in tests_by_suite)
		test_suite(suite)
