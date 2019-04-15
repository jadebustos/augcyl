#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Programa que busca al usuario que ejecuta el script 
# en una maquina via el fichero /etc/passwd

$logname = $ARGV[0];	# Ojo con estas cosas!!!!. Posibles fallos de seguridad

if($logname ne 'root')
{
   print "No eres el superusuario!\n";
}

open(PASSWD,"/etc/passwd");
@lines = <PASSWD>;
close(PASSWD);

foreach $line(@lines)
{
   @tokens = split(/:/,$line);
   if($tokens[0] eq $logname)
   {
	print "Usuario $logname encontrado!\n";
	print "uid = $tokens[2]\n";
	print "gid = $tokens[3]\n";
	print "Nombre completo = $tokens[4]\n";
	print "home = $tokens[5]\n";
   }
}
