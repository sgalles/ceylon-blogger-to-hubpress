import ceylon.regex {

	regex,
	Regex
}
class RegexSplitIterable(String wholeString, String regexString) satisfies {String+}{
	shared actual Iterator<String> iterator() => object satisfies Iterator<String> {
		Regex re = regex{
			expression = regexString;
			global = true;
		};
		
		variable Integer? oldLastIndex = 0;
	
		shared actual String|Finished next() {
			if(exists oldLastIndexCst = oldLastIndex){
					if(exists matchResult = re.find(wholeString)){
						value segment = wholeString[oldLastIndexCst..re.lastIndex-1];
						oldLastIndex = re.lastIndex;
						return segment;
						
					} else { 
						oldLastIndex = null;
						return wholeString[oldLastIndexCst...]; 
					}
			}else{
				return finished;
			}
		}
				
	};
}