#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------


# Ejemplo de subrutinas con paso de referencias

@array = (2, 1, 3, 4, 5, 6, 67, 3, 2, 1);
%hash = ("s1"=>2, "s2"=>5, "s3"=>-3);

# Llamada a las subrutinas
$max = findMax(\@array);
print "El maximo numero en el array es $max\n";
$max = findMaxHash(\%hash);
print "El maximo numero en el hash es $max\n";


#-----------------------------------------------------------------------------
#	Definicion de subrutinas
#-----------------------------------------------------------------------------

sub findMax
# En $_[0] esta la referencia a @array
{
   $maximo = $_[0][0];
   print "$maximo--\n";
   foreach $n(@{$_[0]})
   {
      if($n > $maximo) { $maximo = $n; }
   }
   return $maximo;
}

#-----------------------------------------------------------------------------

sub findMaxHash
# En $_[0] esta la referencia a %hash
{
   ($key,$maximo) = each( %{$_[0]} );
   while( ($key,$n) = each(%{$_[0]}) )
   {
      if($n > $maximo) { $maximo = $n; }
   }
   return $maximo;
}

#-----------------------------------------------------------------------------
