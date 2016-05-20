
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
class AsciidocBlogArticle(shared String asciidocContent, shared String title, shared String published) {
	
	
	string => "BlogArticle:``title``:``published``\nhtml=``asciidocContent``";
	
	
}