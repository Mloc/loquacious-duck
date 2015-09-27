#define TEST(test_name) \
	dmut/unit_test/test_name { \
		__structural = 0; \
		__name = #test_name}; \
	dmut/unit_test/test_name/run_test(exception/liason)

#define TEST_FIXTURE(fixture_name, test_name) \
	TEST(__fixture/fixture_name/test_name)

#define __DMUT_FAIL(msg) \
	liason.name = msg; \
	liason.file = __FILE__; \
	liason.line = __LINE__; \
	return 1

#define DEFINE_FIXTURE(fixture_name) \
	/dmut/unit_test/__fixture/fixture_name

#define CHECK(expression) \
	if(!(expression)) {__DMUT_FAIL("assertion '" + #expression + "' failed")}

#define CHECK_EQUAL(a, b) \
	if(a != b) {__DMUT_FAIL("'" + #a + "' ([a]) is not equal to '" + #b + "' ([b])")}

// helper for generic list equality
#define CHECK_LIST_EQUAL(list_a, list_b) \
	if(!__compare_lists(list_a, list_b)) {__DMUT_FAIL("'" + #list_a + "' is not equal to '" + #list_b + "'")}

// `do {...} while(0)` opens a new, breakable scope
#define CHECK_THROW(expression, exception_type) \
	do { \
		try {expression}; \
		catch(var/exception/e) { \
			if(!istype(e, exception_type)) {__DMUT_FAIL("expression '" + #expression + "' threw '[e.type] ([e.name]/[e.file]:[e.line])' instead of '[exception_type]'");} \
			break}; \
		__DMUT_FAIL("expression '" + #expression + "' failed to throw '[exception_type]'") \
	} while(0)

/dmut/unit_test
	var/__structural = 1
	var/__name = null
	var/__fixture = 0
	proc/run_test(liason)

	proc/__compare_lists(list/a, list/b)
		if(a.len != b.len) return 0
		if(a.len == 0) return 1
		for(var/i = 1; i <= a.len; i++)
			if(a[i] != b[i]) return 0
		return 1

/dmut/unit_test/__fixture
	__fixture = 1
	proc/fixture_setup()
	proc/fixture_destroy()


/datum/dmut_tester

/proc/run_tests()
	var/list/tests = list()

	for(var/p in typesof(/dmut/unit_test))
		var/dmut/unit_test/utp = p
		if(initial(utp.__structural) == 0)
			tests += p

	var/failc = 0
	var/exception/liason = new
	for(var/p in tests)
		var/dmut/unit_test/__fixture/test = new p

		var/retval = null
		try
			if(test.__fixture)
				test.fixture_setup()

			retval = test.run_test(liason)

			if(test.__fixture)
				test.fixture_destroy()
		catch(var/exception/e)
			retval = 1
			liason.name = "unhandled exception '[e.type] ([e.name])'"
			liason.file = e.file
			liason.line = e.line
		
		if(retval == 1)
			failc++
			world.log << "[liason.file]:[liason.line]: error: Test failure in [test.__name]: [liason.name]"
	
	world.log << tests.len
	world.log << failc

/world/New()
	run_tests()
	del(src)
