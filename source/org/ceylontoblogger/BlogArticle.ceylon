
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
class BlogArticle(shared String htmlContent, shared String title) {
	print("Processing ``title``");
	Tidy tidy = Tidy();
	value writer = StringWriter();
	shared Document dom = tidy.parseDOM(StringReader(htmlContent.replace("&lt;br /&gt;", "@@@br@@@")), writer);
	
	string => "BlogArticle:``title``:\nhtml=``htmlContent``\ntidy=``writer``";
	
	
}