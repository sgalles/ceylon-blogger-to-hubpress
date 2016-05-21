import ceylon.file {

	Nil,
	Directory
}


void saveAsciidocBlogPost(Integer->AsciidocBlogArticle indexAsciidocBlogPost) {
	if (is Directory dir = workDir.resource) {
		value filePath = dir.childResource("``indexAsciidocBlogPost.item.published``-``indexAsciidocBlogPost.key``.adoc");
		if (is Nil loc = filePath) {
			value file = loc.createFile();
			try (writer = file.Overwriter()) {
				writer.write(indexAsciidocBlogPost.item.asciidocContent);
			}
		}
		else {
			print("file already exists : ``filePath``");
		}
	}else{
		throw Exception("``workDir.absolutePath`` does not exists");
	}
}