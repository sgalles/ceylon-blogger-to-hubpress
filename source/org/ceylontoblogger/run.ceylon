import ceylon.interop.java {
	CeylonList
}
import ceylon.regex {
	regex,
	Regex
}

import org.jdom2 {
	Document,
	Element,
	Content,
	Namespace
}
import org.jdom2.input {
	SAXBuilder
}
import org.w3c.dom {

	Node
}

String xmlSource = "blog-04-16-2016.xml";
SAXBuilder jdomBuilder = SAXBuilder();


String removeHtmlBreakFromTextarea(String rawHtml) =>
	"".join(
		RegexSplitIterable(rawHtml, "</?(?:textarea)[^>]*>")
			.indexed
			.map((indexAndSplited) => let (index->splited = indexAndSplited)
					if (index.even) 
					then splited.full 
					else splited.element.replace("<br />", "\n")
										.replace("<", "&lt;")
										.replace(">", "&gt;") + splited.separator
		)
	);

	

"Run the module `org.ceylontoblogger`."
shared void run() {
	
	Document jdomDocument = jdomBuilder.build(xmlSource);
	Element rss = jdomDocument.rootElement;
	Namespace ns = Namespace.getNamespace("http://www.w3.org/2005/Atom");
	Namespace nsApp = Namespace.getNamespace("app","http://purl.org/atom/app#");
	
	
	CeylonList<Content> rssContents = CeylonList(rss.content);
	
	{Element*} xmlBlogEntries = rssContents.narrow<Element>().filter((Element e) 
		=>  let( isBlog = CeylonList(e.getChildren("category", ns)).any((Element category) 
					=> category.getAttribute("term").\ivalue.endsWith("#post")))
			let (isDraft = e.getChild("control", nsApp) exists)
			isBlog && !isDraft
	);

	{HtmlBlogArticle*} blogArticles = xmlBlogEntries.map((Element e) => 
		let(title = e.getChild("title", ns).\ivalue)
		let(published = e.getChild("published", ns).\ivalue)
		let(bloggerHtml = e.getChild("content", ns).\ivalue)
	    let(rawHtml = "<!DOCTYPE html><html><head><title>``title``</title></head><body>``bloggerHtml``</body></html>")
	    let(html = removeHtmlBreakFromTextarea(rawHtml))
		HtmlBlogArticle{
			htmlContent = html;
			title = title;
			published = published.split('T'.equals).first;
		}
	);	
	
	assert(exists blog = blogArticles.getFromFirst(7));
	blog.printTree();
	
	HtmlToAsciidocTransformer transformer = HtmlToAsciidocTransformer();
	try {
		blog.recurse(transformer.recursing);
	}catch(e){
		e.printStackTrace();
	}
	print("##########################");
	print(transformer);
}

