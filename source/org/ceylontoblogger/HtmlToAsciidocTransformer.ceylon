import ceylon.collection {
	HashMap
}

import org.w3c.dom {
	Node
}

import org.ceylontoblogger{
	Step {start,end}
}

String? ignore(Node n, Step s) => null;

class HtmlToAsciidocTransformer() {
	
	StringBuilder sb = StringBuilder();
	
	
	
	Map<String, String?(Node,Step)> handlers = HashMap{
		"html" -> ignore,
		"head" -> ignore,
		"meta" -> ignore,
		"body" -> ignore,
		
		"title" -> ((Node n, Step s)=> switch(s) 
			case(start) "= ``n.nodeValue``" 
			case(end) "\n\n"),
		
		"#text" -> ((Node n, Step s)
			=>( if(s == start) then "``n.nodeValue``" else null)), 
		
		"br" -> ((Node n, Step s) 
			=> " +\n"),
		
		"i" -> ((Node n, Step s) 
			=> "_")
		
	
	};
	
	string => sb.string;
	
	shared void recursing([Node+] path, Step step){
		value node = path.last;
		if(exists handler = handlers.get(node.nodeName)){
			if(exists s = handler(node, step)){
				sb.append(s);
			}
		}else{
			throw Exception("Not handler for '``node.nodeName``'");
		}
	}
	
	
}