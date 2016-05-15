import ceylon.file {
	Path
}

import org.w3c.dom {
	Document,
	Node,
	NodeList,
	NamedNodeMap
}

class IterableNodeList(NodeList nodeList) satisfies {Node*}{
	shared actual Iterator<Node> iterator() => object satisfies Iterator<Node> {
		variable Integer i = 0;
		shared actual Node|Finished next() => if(i < nodeList.length) then nodeList.item(i++) else finished; 
	};
}


class Step of start|end{
	String name;
	shared new start{name="start";}
	shared new end{name="end";}
	string => name;
}

class IterableNode(Node node) satisfies {Node*}{
	value iterableNodeList = IterableNodeList(node.childNodes);
	shared actual Iterator<Node> iterator() => iterableNodeList.iterator();
	
	shared void recurse(void recursing([Node+] path, Step step)){
		internalRecurse([node], recursing);
	}
	
	void internalRecurse([Node+] path, void recursing([Node+] path, Step step)){
		recursing(path, Step.start);
		for(childNode in IterableNode(path.last)){
			internalRecurse(path.withTrailing(childNode), recursing);
		}
		recursing(path, Step.end);
	}
}

class NodeAttributes(Node node) satisfies Map<String,String>{
	
	NamedNodeMap? attributes = node.attributes;
	
	shared actual Map<String,String> clone() => nothing;
	
	shared actual Boolean defines(Object key) 
			=> get(key) exists;  
	
	shared actual String? get(Object key) 
			=>  if(is String key) then attributes?.getNamedItem(key)?.nodeValue
				else null;
				
	shared actual Iterator<String->String> iterator() 
		=> 	if(exists attributes) 
			then object satisfies Iterator<String->String> {
				variable Integer i = 0;
				shared actual <String->String>|Finished next() 
						=> 	if(i < attributes.length) 
							then let(n = attributes.item(i++)) n.nodeName-> n.nodeValue 
							else finished; 
			} 
			else emptyIterator;			
	
	shared actual Integer hash => node.hash;
	
	shared actual Boolean equals(Object that) {
		if (is NodeAttributes that) {
			return node==that.node;
		}
		else {
			return false;
		}
	}
	
	
}

class AsciidocBlogArticle {
	Document document;
	shared new (HtmlBlogArticle htmlArticle){
		document = htmlArticle.dom;
		value racine = document.documentElement;
		
		IterableNode(racine).recurse(void ([Node+] path, Step step) {
			print("``path.map(Node.nodeName)``:``step``:``path.last.nodeValue``@``NodeAttributes(path.last)``");
		});
	}
	
	shared void recurse(void recursing([Node+] path, Step step)){
		value root = document.documentElement;
		IterableNode(root).recurse(recursing);
	}
	
	
}