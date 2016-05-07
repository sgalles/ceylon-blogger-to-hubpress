
import java.io {
	StringReader,
	StringWriter
}

import org.w3c.dom {
	Document
}
import org.w3c.tidy {
	Tidy
}
class HtmlBlogArticle(shared String htmlContent, shared String title) {
	Tidy tidy = Tidy();
	value writer = StringWriter();
	shared Document dom = tidy.parseDOM(StringReader(htmlContent), writer);
	
	string => "BlogArticle:``title``:\nhtml=``htmlContent``\ntidy=``writer``";
	
	
}