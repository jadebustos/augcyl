#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Programa que lee un fichero y si encuentra una ruta (ej: /home/users/) borra
# el / al final

open (FILE, "$ARGV[0]");

while($line=<FILE>)
{
   $line =~ s/((\w|\/)+)(\/)/$1/;
   print $line;
}

close(FILE);
