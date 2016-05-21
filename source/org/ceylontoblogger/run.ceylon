import ceylon.file {
	parsePath,
	Path
}

import org.jdom2 {
	Element
}

Path workDir = parsePath("work");

String xmlSource = "blog-04-16-2016.xml";


"Run the module `org.ceylontoblogger`."
shared void run() {
	{Element*} xmlBlogEntries = splitBloggerXmlBackup(xmlSource);
	{RawHtmlBlogArticle*} rawblogArticles = xmlBlogEntries.map(xmlBlogEntryToRawHtmlBlogEntry);	
	{HtmlBlogArticle*} blogArticles = rawblogArticles.map(rawHtmlToHtmlBlogPost);
	{AsciidocBlogArticle*} asciidocBlogs = blogArticles.map(htmlToAsciidocBlog);
	asciidocBlogs.indexed.each(saveAsciidocBlogPost);
}

