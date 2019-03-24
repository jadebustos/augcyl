#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Modelo de servidor con transferencia de ficheros 

use Socket;

$port = $ARGV[0];

# Abrimos un fichero de log donde guardaremos incidencias, errores, ...
$logfile = "server.log";
open(LOG,">> $logfile");

# Creamos el socket
$proto = getprotobyname('tcp');
socket(S,AF_INET,SOCK_STREAM,$proto) || die "socket: $!";   # $!(tipo de error)
$time = gmtime;
print LOG "Nueva session en $time\n";

($name, $aliases,$type,$len,$local) = gethostbyname('localhost');

# Se empaquetan las direcciones en el formato requerido
$sockaddr = 'S n a4 x8';
$localaddr  = pack($sockaddr, AF_INET, $port, $local);

# Se asocia el socket 
bind(S, $localaddr) || die "bind: $!";
listen(S,10) || die "listen: $!";
print LOG "Servidor escuchando en el puerto $port...\n";

# Se acepta una conexion de un cliente y se cambia de socket para atenderla
$clientaddr = accept(C,S) || die "accept: $!";
select C; $| = 1; select STDOUT;
$time = gmtime;
# Desempaquetamos la direccion del cliente que llama
($family, $port, $ip) = unpack($sockaddr,$clientaddr);
$ip = gethostbyaddr($ip,AF_INET);
print LOG "Aceptada conexion del cliente $ip por el puerto $port en $time\n";
select LOG; $| = 1; select STDOUT;

# Confirmamos inicio de sesion
print C "__INIT\n";

# Esperamos un comando del cliente
while($command = <C>)
{
   chop $command;
   # Listado de ficheros en el directorio actual
   if($command eq '__DIR')
   {
	print LOG "Recibido __DIR del cliente\n";
	@files = `/bin/ls * -d`;
        for($i=0; $i<=$#files; $i++) 
        { 
	   chop $files[$i];
	   # Si es un directorio se le concatena el '/'
	   if(-d $files[$i]) { $files[$i]="$files[$i]/"; }
	   # Si el nombre tiene espacios en blanco se sustituyen por %20
	   $files[$i] =~ s/ /%20/;
	}
	# Se manda como una unica cadena
        print C "@files\n";
   }
   # Transferencia de ficheros
   elsif($command eq "__GET")
   {
	do
	{
	   $line = <C>;   chop $line;
	   if($line eq "__FILE")    # Un nuevo fichero
	   {
	      $filename = <C>; chop $filename;
	      if(-e $filename)   # Si existe...
	      {
	         print C "__DATA\n";   # Confirma que empieza a mandar datos
		 open(FILE, "$filename");
		 do
		 {
		   $bytes = read(FILE,$buffer,256);# En paquetes de 1024 bytes
		   if($bytes>0){ print "--> $bytes\n"; print C "$buffer\n"; }
	         } while ($bytes>0);
		 close(FILE);
		 print C "__ENDDATA\n";
	      }
	      else { print C "__FAIL\n"; }
	   }
	} while ($line ne "__ENDFILES");   # Ya no hay mas ficheros que transf.
   }
}

exit;

