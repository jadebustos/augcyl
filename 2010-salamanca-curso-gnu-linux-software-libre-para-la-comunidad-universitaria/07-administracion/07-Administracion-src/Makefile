NUMERO=07
NOMBRE=Administracion

all: valid pdf html

valid:
	xmllint --valid --noout 00-$(NOMBRE).xml
	
pdf:
	dblatex 00-$(NOMBRE).xml
	mv -f 00-$(NOMBRE).pdf ../$(NUMERO)-$(NOMBRE).pdf

html:
	docbook2html 00-$(NOMBRE).xml
	mkdir $(NUMERO)-$(NOMBRE)-html/
	mv -f *.html $(NUMERO)-$(NOMBRE)-html/
	cp -Rf img/ $(NUMERO)-$(NOMBRE)-html/
	chmod 755 $(NUMERO)-$(NOMBRE)-html/img
	tar -zcf ../$(NUMERO)-$(NOMBRE)-html.tgz $(NUMERO)-$(NOMBRE)-html/
	rm -Rf $(NUMERO)-$(NOMBRE)-html/

