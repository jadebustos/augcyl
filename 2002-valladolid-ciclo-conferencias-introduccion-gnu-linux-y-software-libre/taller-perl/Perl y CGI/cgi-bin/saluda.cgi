#!/usr/bin/perl
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

#----------------------------------------------------------------------------
# Parte del tratamiento de la informacion
#----------------------------------------------------------------------------

$line = $ENV{QUERY_STRING};
@inputs = split(/&/,$line);

$inputs[0] =~ s/sexo=//;
if($inputs[0] eq 'M')
{
   $sexo = 'Sr.';
}
else
{
   $sexo = 'Srta.';
}

$inputs[1] =~ s/nombre=//;
$inputs[1] =~ s/\+/ /;
$nombre = $inputs[1];

#----------------------------------------------------------------------------
# Parte de generacion de respuesta
#----------------------------------------------------------------------------

print "Content-type: text/html \n\n";

print "<head><title> Taller de Perl - CGI-Perl : Respuesta</title></head>\n";
print "<body bgcolor=#FFFFFFFF>\n";
print "<center><h1> Respuesta personalizada</h1></center> <br><br>\n";
print "Hola $sexo $nombre, encantado de que visite nuestra pagina web\n";
print "</body>\n";
print "</html>\n";
