#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Declaracion de escalares numericos y operaciones con ellos
$n1 = 2;	# declaramos un entero
$n2 = 3.5;	# declaramos un real

$suma = $n1 + $n2;
print "La suma de $n1 y $n2 = $suma\n";

$multi = $n1 * $n2;
print "La multiplicacion de $n1 por $n2 = $multi\n";

$div = $n1 / $n2;
$mod = $n1 % $n2;
print "La division y le modulo de $n1 entre $n2 dan respectivamente $div y $mod\n";

$n1++;
print "2++ = $n1\n";

$n2--;		# tambien vale para los reales!
print "3.5-- = $n2\n";


# cadenas de caracteres
$string1 = "Hola";
$string2 = " mundo!\n";
# Concatenacion de dos strings
$string = $string1.$string2;
print $string;
