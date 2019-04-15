#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Programa que partiendo de una plantilla de una carta y una lista de registros
# elabora varias cartas personalizadas

open(RECS, "records.txt");
 
open(PLANT, "plantilla.txt");
   @plantilla = <PLANT>;
close(PLANT);

$firmante = $ARGV[0];
($sec,$min,$hour,$mday,$mon,$year,$wday,$yday) = gmtime;
$fecha = "$mday de $mon de $year";

while($line=<RECS>)
{
   chop $line;
   @tokens = split(/:/,$line);   
   open(CARTA,"> $tokens[0].txt");
      foreach $line2(@plantilla)
      {
	  # Guardamos la linea en un variable temporal para no cargarnos la
	  # plantilla
   	  $line3 = $line2;
	  $line3 =~ s/\[DIRECCION\]/$tokens[1]/;
	  $line3 =~ s/\[FECHA\]/$fecha/;
	  $line3 =~ s/\[DESTINO\]/$tokens[0]/;
 	  $line3 =~ s/\[FIRMANTE\]/$firmante/;
	  print CARTA "$line3";
      }
   close(CARTA);
   # vamos a por el siguiente destinatario en records.txt
}

close(RECS);
