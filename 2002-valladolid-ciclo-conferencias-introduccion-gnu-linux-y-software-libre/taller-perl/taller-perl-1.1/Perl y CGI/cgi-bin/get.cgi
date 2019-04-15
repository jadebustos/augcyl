#!/usr/bin/perl
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

print "Content-type: text/html \n\n";
print ("<!-- Esta pagina fue generada de manera dinamica -->\n");
print ("<html>\n");
print ("<head>\n");
print ("<title>\"Taller de Perl - CGI-Perl: Metodo GET\"</title>\n");
print ("</head>\n");
print ("<body bgcolor=white>\n");
print ("<center>");
print ("<h1><font color=blue>Metodo GET</font></h1><br>\n");
print ("</center>");
print("<hr WIDTH='100%'>\n");
print ("Cliente <font color=red>$ENV{REMOTE_ADDR}</font>, ");
print ("el contenido de la variable <font color=blue>QUERY_STRING</font> ");
print ("es: $ENV{QUERY_STRING}\n");
print ("</body>\n");
print ("</html>\n");


