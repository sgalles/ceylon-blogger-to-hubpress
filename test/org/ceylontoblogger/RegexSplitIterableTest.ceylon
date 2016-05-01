import ceylon.test {
	test,
	assertEquals
}
class RegexSplitIterableTest() {
	
	String regexString = "bar";
	
	test
	shared void shouldReturnWholeStringWhenNotMatching(){
		assertEquals(RegexSplitIterable("foo",regexString).sequence(), ["foo"]);
		assertEquals(RegexSplitIterable("",regexString).sequence(),[""]);
	}
	
	test
	shared void shouldReturnTwoStringsForOneMatch(){
		assertEquals( RegexSplitIterable("foobarbaz",regexString).sequence(), ["foobar","baz"]);
		assertEquals( RegexSplitIterable("foobar",regexString).sequence(), ["foobar",""]);
	}
	
	test
	shared void shouldReturnThreeStringsForTwoMatches(){
		assertEquals( RegexSplitIterable("foobarbazbar",regexString).sequence(), ["foobar","bazbar", ""]);
		assertEquals( RegexSplitIterable("foobarbazbartoto",regexString).sequence(), ["foobar","bazbar", "toto"]);
	}
	
	
	
}