#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@mixmail.com>
#-----------------------------------------------------------------------------

# Ejemplo de definicion y manipulacion de arrays
@array1 = ();		  # definicion de un array vacio
@array2 = ("Maria",23);   # definicion e inicializacion de un array
@personas = ();

# Uso del push
push(@array1,"Juan");
push(@array1,27);
push(@personas,@array1);
push(@personas,@array2);

print "@personas\n";	# el array es convertido a una cadena de caracteres
			# y los elementos se imprimen separados por blancos

# Uso del pop
$elemento = pop(@personas);
print "$elemento\n";
print @personas;	# todos los elementos se imprimen seguidos

# reverse
@personas_inv = reverse @personas;
print "\n@personas_inv\n";

#sort
@ordenado = sort(@personas);
print "@ordenado\n";

# shift, unshift y splice
shift(@personas);
print "@personas\n";
unshift(@personas,"cadena");
print "@personas\n";
splice(@personas,1,2);
print "@personas\n";
