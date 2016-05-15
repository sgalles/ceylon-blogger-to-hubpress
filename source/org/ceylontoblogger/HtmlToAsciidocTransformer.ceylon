import ceylon.collection {
	HashMap
}
import ceylon.language {
	null
}

import org.ceylontoblogger {
	Step {start,end}
}
import org.w3c.dom {
	Node
}

String? ignore(Node n, Step s) => null;

class HtmlToAsciidocTransformer() {
	
	StringBuilder sb = StringBuilder();
	
	String none = "";
	
	Map<String, Null|String|String(Node)|[<Step-><String(Node)|String>>+]> handlers = HashMap{
		"html" -> none,
		"head" -> none,
		"meta" -> none,
		"body" -> none,
		
		"title" -> [
			start -> ( (Node n)=>"= ``n.nodeValue``"),
			end -> "\n\n"
		],
			
		"#text" -> [
			start -> ( (Node n)=>"``n.nodeValue``" )
		],	
			
		"br" -> [
			start -> "\n\n"
		],
			
		"i" -> "_",
			
		"span" -> [
			start -> ( (Node n)=>if(exists style = MapNode(n).get("style")) then " " else nothing )
		],
		"a" ->  [
			start -> ( (Node n) => let(href = MapNode(n).get("href") else nothing) "link:``href``[" ),
			end -> "]"
		],	
		"u" -> null,
		"ul" -> "\n",	
		
		"li" -> [
			start -> "* " ,
			end -> "\n"
		],
		"textarea" -> [
			start -> ( (Node n) {
						if(exists clazz = MapNode(n).get("class")){
							value syntaxIs = clazz.startsWith;
							if(syntaxIs("xml")){
								return "\n\n[source,xml]\n----\n";
							}else{
								throw Exception("Unknown textarea class : ``clazz``" );
							}
						}else{
							throw Exception("textarea class does not have a class :``n.nodeValue``" );
						}
					}),
			end -> "----\n"		
		]

	};
	
	string => sb.string;
	
	shared void recursing([Node+] path, Step step){
		value node = path.last;
		if(exists handler = handlers.get(node.nodeName)){
			switch(handler)
			case (is String) {
				sb.append(handler);
			}
			case (is String(Node)) {
				sb.append(handler(node));
			}
			case (is [<Step-><String(Node)|String>>+]) {
				if(exists handlerForStep = HashMap{*handler}[step]){
					switch(handlerForStep)
					case (is String) {
						sb.append(handlerForStep);
					}
					case (is String(Node)) {
						sb.append(handlerForStep(node));
					}
				}	
			}
		}else{
			throw Exception("Not handler for '``node.nodeName``'");
		}
	}
	
	
}