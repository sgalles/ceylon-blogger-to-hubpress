import ceylon.test {
	test,
	assertEquals
}
class RegexSplitIterableTest() {
	
	String regexString = "bar";
	
	test
	shared void shouldReturnWholeStringWhenNotMatching(){
		assertEquals(RegexSplitIterable("foo",regexString).sequence(), [Segment("foo")]);
		assertEquals(RegexSplitIterable("",regexString).sequence(),[Segment("")]);
	}
	
	test
	shared void shouldReturnTwoStringsForOneMatch(){
		assertEquals( RegexSplitIterable("foobarbaz",regexString).sequence(), [Segment("foo","bar"),Segment("baz")]);
		assertEquals( RegexSplitIterable("foobar",regexString).sequence(), [Segment("foo","bar"),Segment("")]);
	}
	
	test
	shared void shouldReturnThreeStringsForTwoMatches(){
		assertEquals( RegexSplitIterable("foobarbazbar",regexString).sequence(), [Segment("foo","bar"),Segment("baz","bar"), Segment("")]);
		assertEquals( RegexSplitIterable("foobarbazbartoto",regexString).sequence(), [Segment("foo","bar"),Segment("baz","bar"), Segment("toto")]);
	}
	
	
	
}