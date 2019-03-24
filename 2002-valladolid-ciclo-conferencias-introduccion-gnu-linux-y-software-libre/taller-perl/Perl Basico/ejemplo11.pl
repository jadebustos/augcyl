#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Uso de expresiones regulares
$colores = "azul rojo amarillo verde naranja negro verde blanco";
$result = ($colores =~ /verde/);
print "El resultado de una expresion =~ con acierto es: $result\n";
$result = ($colores =~ /violeta/);
print "El resultado de una expresion =~ sin acierto es: $result\n";

