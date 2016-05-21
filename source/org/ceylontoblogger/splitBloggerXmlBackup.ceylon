import ceylon.interop.java {
	CeylonList
}

import org.jdom2 {
	Element,
	Document,
	Content,
	Namespace
}
import org.jdom2.input {
	SAXBuilder
}

Namespace ns = Namespace.getNamespace("http://www.w3.org/2005/Atom");
Namespace nsApp = Namespace.getNamespace("app","http://purl.org/atom/app#");


{Element*} splitBloggerXmlBackup(String xmlSource) {
	SAXBuilder jdomBuilder = SAXBuilder();
	Document jdomDocument = jdomBuilder.build(xmlSource);
	Element rss = jdomDocument.rootElement;
	
	
	CeylonList<Content> rssContents = CeylonList(rss.content);
	
	{Element*} xmlBlogEntries = rssContents.narrow<Element>().filter((Element e) 
		=>  let( isBlog = CeylonList(e.getChildren("category", ns)).any((Element category) 
		=> category.getAttribute("term").\ivalue.endsWith("#post")))
		let (isDraft = e.getChild("control", nsApp) exists)
		isBlog && !isDraft
	);
	return xmlBlogEntries;
}