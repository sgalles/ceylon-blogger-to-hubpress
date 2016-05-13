import ceylon.collection {
	HashMap
}

import org.w3c.dom {
	Node
}
class HtmlToAsciidocTransformer() {
	
	StringBuilder sb = StringBuilder();
	
	Map<String, Anything(Node)> handlers = HashMap{
		"html" -> noop,
		"head" -> noop,
		"meta" -> noop,
		"title" -> (void(Node node){
			sb.append("= ``node.nodeValue``");
		}),
		"#text" -> (void(Node node){
			sb.append("``node.nodeValue``");
		})
		
		/*,
		"#test" -> (void(Node node){
			
		}),
		"#test" -> noop*/
	};
	
	shared void recursing(Node node, String[] path, Step step){
		if(exists handler = handlers.get(node.nodeName)){
			handler(node);
		}else{
			throw Exception("Not handler for '``node.nodeName``'");
		}
	}
	
	string = sb.string;
}