import org.jdom2 {

	Element
}


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

RawHtmlBlogArticle xmlBlogEntryToRawHtmlBlogEntry(Element e) => 
		let(title = e.getChild("title", ns).\ivalue)
		let(published = e.getChild("published", ns).\ivalue)
		let(bloggerHtml = e.getChild("content", ns).\ivalue)
	    let(rawHtml = "<!DOCTYPE html><html><head><title>``title``</title></head><body>``bloggerHtml``</body></html>")
	    let(html = removeHtmlBreakFromTextarea(rawHtml))
		RawHtmlBlogArticle{
			rawHtml = html;
			title = title;
			published = published.split('T'.equals).first;
		};