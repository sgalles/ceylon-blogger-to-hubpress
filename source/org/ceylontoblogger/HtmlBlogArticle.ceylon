
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
	
	shared void recurse(void recursing([Node+] path, Step step)){
		value root = dom.documentElement;
		IterableNode(root).recurse(recursing);
	}
	
	shared void printTree() => recurse(void ([Node+] path, Step step) {
			print("``path.map(Node.nodeName)``:``step``:``path.last.nodeValue``@``MapNode(path.last)``");
		});
	
	
}