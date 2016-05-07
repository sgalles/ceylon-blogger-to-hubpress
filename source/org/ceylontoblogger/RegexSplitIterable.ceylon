import ceylon.regex {

	regex,
	Regex
}
class RegexSplitIterable(String wholeString, String regexString) satisfies {Segment+}{
	shared actual Iterator<Segment> iterator() => object satisfies Iterator<Segment> {
		Regex re = regex{
			expression = regexString;
			global = true;
		};
		
		variable Integer? oldLastIndex = 0;
	
		shared actual Segment|Finished next() {
			if(exists oldLastIndexCst = oldLastIndex){
					if(exists matchResult = re.find(wholeString)){
						oldLastIndex = re.lastIndex;
						return Segment{
							element = wholeString[oldLastIndexCst..matchResult.start-1];
							separator = matchResult.matched;
						};
						
					} else { 
						oldLastIndex = null;
						return Segment{
							element = wholeString[oldLastIndexCst...];
						};
					}
			}else{
				return finished;
			}
		}
				
	};
}

class Segment(shared String element, shared String separator = ""){
	string = "{``element``|``separator``}";
	shared String full = element + separator;
	shared actual Boolean equals(Object that) {
		if (is Segment that) {
			return element==that.element && 
				separator==that.separator;
		}
		else {
			return false;
		}
	}
	shared actual Integer hash {
		variable value hash = 1;
		hash = 31*hash + element.hash;
		hash = 31*hash + separator.hash;
		return hash;
	}
}