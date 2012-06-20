feed.xml: index.xml feed.xsl
	xsltproc feed.xsl $< > $@

index.xml: $(wildcard data-*.xml)
	sh -c 'echo "<index>"; for f in data-*.xml; do echo "<file>$$f</file>"; done; echo "</index>"' > $@

mail-%.txt: data-%.xml mail.xsl
	xsltproc mail.xsl $< > $@

.PHONY: clean
clean:
	rm -f index.xml feed.xml
