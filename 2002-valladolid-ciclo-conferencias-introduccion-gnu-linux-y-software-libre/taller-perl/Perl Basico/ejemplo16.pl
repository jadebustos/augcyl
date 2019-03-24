#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Ejemplo del uso del fork para crear varios procesos

$pid = 1;
@hijos = ();

for($i=0; $i<5; $i++)
{
   if($pid!=0) 
   { 
      $pid = fork(); 
      push(@hijos,$pid);
   }
}

if($pid!=0)
{
   # Soy el padre
   print "Esperando a que acaben los hijos...\n";
   do
   {
      waitpid($hijos[0],0);
      shift @hijos;
      
   } until ($#hijos==0)
}
else
{
   # Soy un hijo
   $padre = getppid();
   print "Hola, saludos a mi padre $padre desde el hijo $$\n"; 
   # Descomentar la siguiente linea para que los hijos no acaben
   # while(1==1) { ; }
}
