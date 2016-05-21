
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
class HtmlBlogArticle(shared Document dom, shared String title, shared String published) {
	//Tidy tidy = Tidy();
	//value writer = StringWriter();
	//shared Document dom = tidy.parseDOM(StringReader(htmlContent), writer);
	
	//string => "BlogArticle:``title``:``published``\nhtml=``htmlContent``\ntidy=``writer``";
	
	shared void recurse(void recursing([Node+] path, Step step)){
		value root = dom.documentElement;
		IterableNode(root).recurse(recursing);
	}
	
	shared void printTree() => recurse(void ([Node+] path, Step step) {
			print("``path.map(Node.nodeName)``:``step``:``path.last.nodeValue``@``NodeAttributes(path.last)``");
		});
	
	
}

class RawHtmlBlogArticle(shared String rawHtml, shared String title, shared String published) {
	
}

HtmlBlogArticle rawHtmlToHtmlBlogPost(RawHtmlBlogArticle rawPost){
	Tidy tidy = Tidy();
	value writer = StringWriter();
	try(value reader = StringReader(rawPost.rawHtml)){
		Document dom = tidy.parseDOM(reader, writer);
		return  HtmlBlogArticle {
			dom = dom;
			title = rawPost.title;
			published = rawPost.published;
		};
	}
}