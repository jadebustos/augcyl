#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Modelo de cliente con transferencia de ficheros

use Socket;

$host = $ARGV[0];
$port = $ARGV[1];

# Creamos el tipo de socket TCP. Si no nos sabemos el numero del TCP lo
# podemos preguntar con la siguiente funcion
$proto = getprotobyname('tcp');
socket(S,AF_INET,SOCK_STREAM,$proto) || die "socket: $!";   # $!(tipo de error)

# Se empaquetan las direcciones local y remota en el formato que piden
# la funcion bind y la funcion connect. Si para el host se dio su nombre
# en vez de su IP habra que obtener su IP con la funcion gethostbyname
($name, $aliases,$type,$len,$local) = gethostbyname('localhost');
($name, $aliases,$type,$len,$remote) = gethostbyname($host);

# Se empaquetan las direcciones en el formato requerido
$sockaddr = 'S n a4 x8';
$localaddr  = pack($sockaddr, AF_INET, 0, $local);
$remoteaddr = pack($sockaddr, AF_INET, $port, $remote);

# Se asocia el socket y se conecta con la direccion dada
bind(S, $localaddr) || die "bind: $!";
connect(S, $remoteaddr) || die "connect: $!";
select S; $| = 1; select STDOUT;

$line = <S>;
chop $line;
if($line eq '__INIT')
{
   do
   {
      print "command> ";
      $command = <STDIN>;
      chop $command;
      if($command eq 'DIR') 
      { 
	 print S "__DIR\n"; 
	 $filelist = <S>;   chop $filelist;
	 @files = split(/ /,$filelist);
	 foreach $f(@files) 
	 { 
	    $f =~ s/%20/ /;
	    print "$f\n"; 
	 }
      }
      if($command =~ /^GET /)	# Es GET y algo mas
      {
	 @files = split(/ /,$command);
	 shift @files;	# quitamos el GET
	 print S "__GET\n";
	 foreach $f(@files)
	 {
	    print S "__FILE\n";
	    print S "$f\n";
	    $line = <S>;  chop $line;
	    if($line eq "__DATA")
	    {
		open(FILE, "> $f");
		do
		{
		   $data = <S>;   chop $data;
		   if($data ne "__ENDDATA")
		   {
		      print FILE $data;
		   }
		} while ($data ne "__ENDDATA");
		close(FILE);
  	    }
	 }
	 print S "__ENDFILES\n";
      }
   } while ($command ne 'BYE');
}


close(S) || die "close: $!";
exit;
