// ## internal macros
#define __DMUT_CREATESCOPE(test_name, test_path) \
	dmut/test_path { \
		__structural = 0; \
		__name = #test_name}; \
	dmut/test_path/run_test(exception/liason)

#define __DMUT_FAIL(msg) \
	liason.name = msg; \
	liason.file = __FILE__; \
	liason.line = __LINE__; \
	return 1


// ## definition macros
#define SUITE(suite_name) \
	dmut/__suite/suite_name {__suite = #suite_name}; \
	dmut/__suite/suite_name

#define TEST(test_name) \
	__DMUT_CREATESCOPE(test_name, test_name)

#define TEST_FIXTURE(fixture_name, test_name) \
	__DMUT_CREATESCOPE(test_name, __fixture/fixture_name/test_name)

#define FIXTURE(fixture_name) \
	dmut/__fixture/fixture_name {__fixture = #fixture_name}; \
	dmut/__fixture/fixture_name


// ## assertion macros
#define CHECK(expression) \
	if(!(expression)) {__DMUT_FAIL("assertion '" + #expression + "' failed")}

#define CHECK_EQUAL(a, b) \
	if(a != b) {__DMUT_FAIL("'" + #a + "' \[[a]] is not equal to '" + #b + "' \[[b]]")}

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
