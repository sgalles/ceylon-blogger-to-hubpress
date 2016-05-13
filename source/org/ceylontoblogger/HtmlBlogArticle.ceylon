
import java.io {
	StringReader,
	StringWriter
}

import org.w3c.dom {
	Document,
	Node
}
import org.w3c.tidy {
	Tidy
}
class HtmlBlogArticle(shared String htmlContent, shared String title, shared String published) {
	Tidy tidy = Tidy();
	value writer = StringWriter();
	shared Document dom = tidy.parseDOM(StringReader(htmlContent), writer);
	
	string => "BlogArticle:``title``:``published``\nhtml=``htmlContent``\ntidy=``writer``";
	
	shared void recurse(void recursing(Node node, String[] path, Step step)){
		value root = dom.documentElement;
		IterableNode(root).recurse(recursing);
	}
	
	shared void printTree() => recurse(void (Node node, String[] path, Step step){
			print("``path``:``step``:``node.nodeValue``@``MapNode(node)``");
	});
	
	
}