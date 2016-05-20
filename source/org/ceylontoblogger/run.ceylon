import ceylon.file {
	parsePath,
	Directory,
	Path,
	Nil
}
import ceylon.interop.java {
	CeylonList
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

Path workDir = parsePath("work");

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
	
	{AsciidocBlogArticle*} asciidocBlogs = blogArticles.map(htmlToAsciidocBlog);
	for(asciidocBlog in asciidocBlogs.indexed){
		if (is Directory dir = workDir.resource) {
			value filePath = dir.childResource("``asciidocBlog.item.published``-``asciidocBlog.key``.adoc");
			if (is Nil loc = filePath) {
				value file = loc.createFile();
				try (writer = file.Overwriter()) {
					writer.write(asciidocBlog.item.asciidocContent);
				}
			}
			else {
				print("file already exists : ``filePath``");
			}
		}else{
			throw Exception("``workDir.absolutePath`` does not exists");
		}
	}
}

