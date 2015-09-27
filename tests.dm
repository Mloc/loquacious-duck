TEST(sanity)
	CHECK_EQUAL(1, 1)
	CHECK_EQUAL(1, -(-1))
	CHECK_EQUAL("abc", "abc")
	CHECK_EQUAL("ab" + "cd", "abcd")
	CHECK_LIST_EQUAL(list(1, 2, 2, 3), list(1, 2, 2, 3))

DEFINE_FIXTURE(sanity)
	var/a = "b"

	fixture_setup()
		a = "c"
	
	fixture_destroy()
		world.log << "destroying"

TEST_FIXTURE(sanity, fixsanity)
	CHECK_EQUAL("a", a)
