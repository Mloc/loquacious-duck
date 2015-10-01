SUITE(BYONDSanity)
	TEST(Basic)
		CHECK_EQUAL(1, 1)
		CHECK_EQUAL(1, -(-1))
		CHECK_EQUAL("abc", "abc")
		CHECK_EQUAL("ab" + "cd", "abcd")
		CHECK_LIST_EQUAL(list(1, 2, 3), list(1, 2, 3) | list(2, 3))
	
	TEST(FloatRounding)
		CHECK_EQUAL(1, 1.00000001)
		CHECK_EQUAL(10, 10.0000001)
		CHECK_EQUAL(83886008, 83886009)
	
	DEFINE_FIXTURE(ReflectionFixture)
		proc/reflect_target(msg)
			return "REFLECT: [msg]"

		var/data = "abcdef"
	
	TEST_FIXTURE(ReflectionFixture, Reflection)
		CHECK_EQUAL("REFLECT: abcdef", call(src, "reflect_target")(vars["data"]))
