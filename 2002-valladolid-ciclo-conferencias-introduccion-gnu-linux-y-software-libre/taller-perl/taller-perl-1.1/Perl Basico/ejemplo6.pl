#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Bucles
print "\n1. Tabla de multiplicar del 10!\n";
$numero = 0;
$prod = 0;
while ($numero < 10)
{
   $numero++;
   $prod += 10;		# $prod = $prod + 10
   print "$numero x 10 = $prod\n";
}

print "\n2. Otra vez:\n";
for($i = 1; $i<=10; $i++)
{
   $prod = $i * 10;
   print "$numero x 10 = $prod\n";
}
   
@array = (1, -4, 4, 5, 6, -7, 0, 1, -2, 2, 1);
$index = 0;
foreach $n(@array)
{
   $index++;
   if($n > 0)
   {
      print "$n esta en la posicion $index\n";
   }
}
