CATALOG=/etc/sgml/docbook-xml.cat
TAR=/bin/tar
ECHO=/bin/echo
ZIP=/usr/bin/zip
DOCBOOK2PS=/usr/bin/docbook2ps
DOCBOOK2PDF=/usr/bin/docbook2pdf
DOCBOOK2TXT=/usr/bin/docbook2txt
XSLTPROC=/usr/bin/xsltproc
XMLLINT=/usr/bin/xmllint
XSLTFILE=/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/docbook.xsl
CHUNKFILE=/usr/share/sgml/docbook/stylesheet/xsl/nwalsh/html/chunk.xsl

NOMBRE=virtualizacion
OPCIONES=check single multi ps pdf txt comprimidos

all: $(OPCIONES)
	$(ECHO) "Documentos generados y comprimidos"
single: check
	$(XSLTPROC) -o $(NOMBRE).html $(XSLTFILE) $(NOMBRE).xml
multi: check
	$(XSLTPROC) $(CHUNKFILE) $(NOMBRE).xml
ps: check
	$(DOCBOOK2PS) -c $(CATALOG) $(NOMBRE).xml
pdf: check
	$(DOCBOOK2PDF) -c $(CATALOG) $(NOMBRE).xml
comprimidos: txt single multi ps pdf
	$(TAR) jcf $(NOMBRE)-single.tar.bz2 $(NOMBRE).html
	$(TAR) jcf $(NOMBRE)-multi.tar.bz2 *.html
	$(TAR) jcf $(NOMBRE)-pdf.tar.bz2 $(NOMBRE).pdf
	$(TAR) jcf $(NOMBRE)-ps.tar.bz2 $(NOMBRE).ps
	$(TAR) jcf $(NOMBRE)-source.tar.bz2 $(NOMBRE).xml
	$(TAR) zcf $(NOMBRE)-single.tar.gz $(NOMBRE).html
	$(TAR) zcf $(NOMBRE)-multi.tar.gz *.html
	$(TAR) zcf $(NOMBRE)-pdf.tar.gz $(NOMBRE).pdf
	$(TAR) zcf $(NOMBRE)-ps.tar.gz $(NOMBRE).ps
	$(TAR) zcf $(NOMBRE)-source.tar.gz $(NOMBRE).xml
	$(ZIP) $(NOMBRE)-single.zip $(NOMBRE).html
	$(ZIP) $(NOMBRE)-multi.zip *.html
	$(ZIP) $(NOMBRE)-pdf.zip $(NOMBRE).pdf
	$(ZIP) $(NOMBRE)-ps.zip $(NOMBRE).ps
	$(ZIP) $(NOMBRE)-source.zip $(NOMBRE).xml
check:
	$(XMLLINT) --valid --noout $(NOMBRE).xml
txt: check
	$(DOCBOOK2TXT) $(NOMBRE).xml
