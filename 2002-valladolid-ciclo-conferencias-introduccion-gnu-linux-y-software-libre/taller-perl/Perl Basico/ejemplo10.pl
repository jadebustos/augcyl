#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Programa que busca al usuario que ejecuta el script 
# en una maquina via el fichero /etc/passwd

$logname = $ENV{'LOGNAME'};

if($logname ne 'root')
{
   print "No eres el superusuario!\n";
}

open(PASSWD,"/etc/passwd");
@lines = <PASSWD>;
close(PASSWD);

open(INFO,"> $logname.info");
foreach $line(@lines)
{
   @tokens = split(/:/,$line);
   if($tokens[0] eq $logname)
   {
	print INFO "Usuario $logname encontrado!\n";
	print INFO "uid = $tokens[2]\n";
	print INFO "gid = $tokens[3]\n";
	print INFO "Nombre completo = $tokens[4]\n";
	print INFO "home = $tokens[5]\n";
   }
}
close(INFO);
