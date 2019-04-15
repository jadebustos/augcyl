#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Uso de sentencias de control y bucles

# Condicionales
print "Introduzca un numero: ";
$n = <STDIN>;		# lectura por teclado
chop $n;		# eliminamos el \n del final

if($n > 0)
{
   print "El numero $n es positivo\n";
}
else
{
   print "El numero $n es negativo\n";
}

unless ($n>=0 && $n<=9)
{
   print "El numero $n no esta entre 0 y 9\n";
}

