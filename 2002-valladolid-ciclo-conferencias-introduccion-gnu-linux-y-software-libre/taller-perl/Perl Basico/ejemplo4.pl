#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------


# Arrays asociativos
# definicion e inicialicion
%personas = ( "Juan"=>24, "Maria"=>21, "Jesus"=>32 );	
# %personas = ( "Juan", 24, "Maria", 21, "Jesus", 32 );	 # equivalente

# asignacion a un array normal
@personas = %personas;
print "@personas\n";

# delete
delete $personas{"Jesus"};	# borra el elemento con clave "Jesus"
print %personas,"\n";

# each	
$value = each(%personas);	# devuelve la siguiente clave en el hash
print "clave: $value\n";

($key,$value) = each(%personas);   # devuelve clave y valor
print "(key,value) = ($key,$value)\n";

# keys
$nkeys = keys(%personas);
@keys = keys(%personas);
print "El array \@keys tiene $nkeys elementos: @keys\n";

#values
$nvals = values(%personas);
@vals = values(%personas);
print "El array \@vals tiene $nvals elementos: @vals\n";
