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

class IterableNode(Node node) satisfies {Node*}{
	value iterableNodeList = IterableNodeList(node.childNodes);
	shared actual Iterator<Node> iterator() => iterableNodeList.iterator();
	
	shared void recurse(void recursing(Node node, String[] path)){
		internalRecurse(node, [], recursing);
	}
	
	void internalRecurse(Node currentNode, String[] currentPath, void recursing(Node node, String[] path)){
		recursing(currentNode, currentPath);
		for(childNode in IterableNode(currentNode)){
			internalRecurse(childNode, currentPath.withTrailing(childNode.nodeName), recursing);
		}
	}
}

class MapNode(Node node) satisfies Map<String,String>{
	
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
		if (is MapNode that) {
			return node==that.node;
		}
		else {
			return false;
		}
	}
	
	
}

class AsciidocBlogArticle {
	
	shared new (HtmlBlogArticle htmlArticle){
		Document document = htmlArticle.dom;
		value racine = document.documentElement;
		
		//Affichage de l'élément racine
		
		print("\n*************RACINE************");
		
		print(racine.nodeName);
		IterableNode(racine).recurse(void (Node node, String[] path) {
			print("``path``:``node.nodeValue``@``MapNode(node)``");
		});
	}
	
	
}