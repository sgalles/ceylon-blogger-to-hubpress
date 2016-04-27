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

String xmlSource = "blog-04-16-2016.xml";

"Run the module `org.ceylontoblogger`."
shared void run() {
	value jdomBuilder = SAXBuilder();
	Document jdomDocument = jdomBuilder.build(xmlSource);
	Element rss = jdomDocument.rootElement;
	Namespace ns = Namespace.getNamespace("http://www.w3.org/2005/Atom");
	
	CeylonList<Content> rssContents = CeylonList(rss.content);
	
	value blogEntries = rssContents.narrow<Element>().filter((Element entry) 
		=> CeylonList(entry.getChildren("category", ns)).any((category) 
			=> category.getAttribute("term").\ivalue.endsWith("#post")
		)
	);
	blogEntries.each(void(Element entry) {
			print(entry.getChild("title", ns).\ivalue);
		});
}