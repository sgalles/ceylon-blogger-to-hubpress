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
			start -> ( (Node n){
						if(exists style = NodeAttributes(n).get("style")) {
							return " ";
						} else {
							return "";
						}
					})
		],			

		"a" -> (
					let (link = ( 
							(String generating(String href))(Node n) =>
								let(attributes = NodeAttributes(n))
								let(href = attributes.get("href") else nothing) 
								let(onblur = attributes.get("onblur")) // do not generate if <a/> has 'onblur'
								if(! onblur exists) then generating(href) else "" 
					))
					[
						start -> link( (href) => "link:``href``[" ),
						end -> link( (_) => "]" )
					]
				),
					
		"u" -> null,
		"ul" -> "\n",	
		
		"li" -> [
			start -> "\n* " 
		],
		"textarea" -> [
			start -> ( (Node n) {
						if(exists clazz = NodeAttributes(n).get("class")){
							value syntaxIs = clazz.startsWith;
							String syntax;
							if(syntaxIs("xml")){
								syntax = "xml";
							}else if(syntaxIs("ruby")){
								syntax = "ruby";
							}else  if(syntaxIs("bash")){
								syntax = "bash";
							}else{
								throw Exception("Unknown textarea class : ``clazz``" );
							}
							return "\n\n[source,``syntax``]\n----\n";
						}else{
							throw Exception("textarea class does not have a class :``n.nodeValue``" );
						}
					}),
			end -> "----\n"		
		],
		
		"pre" -> "\n\n....\n",
		 	
		"img" ->  [
			start -> ( (Node n) => let(src = NodeAttributes(n).get("src") else nothing) "image::``src``[" ),
			end -> "]\n"
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