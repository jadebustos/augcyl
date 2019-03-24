#!/usr/bin/perl
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

print "Content-type: text/html \n\n";

print "<head><title> Taller de Perl - CGI-Perl : Formulario de datos </title></head>\n";
print "<body bgcolor=#FFFFFFA0>\n";
print "<center><h1> Formulario de envio de datos </h1></center> <br><br>\n";
print "<hr width='100%'> <br>\n";
$server = $ENV{SERVER_NAME};
print "<form action='http://$server/cgi-bin/saluda.cgi' method='GET'>\n";
print "<input type=radio name=sexo value=M>Masculino <br>\n";
print "<input type=radio name=sexo value=F>Femenino  <br><br>\n";
print "Escriba su nombre: <input type=text name='nombre' size=20><br><br>\n";
print "<input type=submit value='Enviar con GET'> <br><br>\n";
print "<input type=reset value='Volver a empezar'> <br><br>\n";
print "</form>\n";
print "<hr width='100%'> <br>\n";
print "</body>\n";
print "</html>\n";
