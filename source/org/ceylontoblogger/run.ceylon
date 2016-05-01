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

String xmlSource = "blog-04-16-2016.xml";
SAXBuilder jdomBuilder = SAXBuilder();


String removeHtmlBreakFromTextarea(String rawHtml) =>
	"".join(
		RegexSplitIterable(rawHtml, "</?(?:textarea|span)[^>]*>")
			.indexed
			.map((indexAndSplited) => let (index->splited = indexAndSplited)
					if (index.even) 
					then splited 
					else splited.replace("<br />", "\n")
								.replace("<", "&lt;")
								.replace(">", "&gt;")
								.replace("&lt;/textarea&gt;", "</textarea>")
								.replace("&lt;/span&gt;", "</span>")
		)
	);

	

"Run the module `org.ceylontoblogger`."
shared void run() {
	
	Document jdomDocument = jdomBuilder.build(xmlSource);
	Element rss = jdomDocument.rootElement;
	Namespace ns = Namespace.getNamespace("http://www.w3.org/2005/Atom");
	
	CeylonList<Content> rssContents = CeylonList(rss.content);
	
	{Element*} xmlBlogEntries = rssContents.narrow<Element>().filter((Element e) 
		=> CeylonList(e.getChildren("category", ns)).any((Element category) 
			=> category.getAttribute("term").\ivalue.endsWith("#post")
		)
	);

	{BlogArticle*} blogArticles = xmlBlogEntries.map((Element e) => 
		let(title = e.getChild("title", ns).\ivalue)
		let(nudeHtml = e.getChild("content", ns).\ivalue)
	    let(rawHtml = "<!DOCTYPE html><html><head><title>``title``</title></head><body>``nudeHtml``</body></html>")
	    let(html = removeHtmlBreakFromTextarea(rawHtml))
		BlogArticle{
			htmlContent = html;
			title = title;
		}
	);	
	
	blogArticles.each(print);
	
}

