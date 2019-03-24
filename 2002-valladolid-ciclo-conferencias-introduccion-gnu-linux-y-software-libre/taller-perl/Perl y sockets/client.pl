#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Modelo de cliente

use Socket;

$host = $ARGV[0];
$port = $ARGV[1];

# 1. Creamos el tipo de socket TCP. Si no nos sabemos el numero del TCP lo
# podemos preguntar con la siguiente funcion
$proto = getprotobyname('tcp');
socket(S,AF_INET,SOCK_STREAM,$proto) || die "socket: $!";   # $!(tipo de error)
print "Creacion del socket del lado del cliente.\n";

# 2. Se empaquetan las direcciones local y remota en el formato que piden
# la funcion bind y la funcion connect. Si para el host se dio su nombre
# en vez de su IP habra que obtener su IP con la funcion gethostbyname
($name, $aliases,$type,$len,$local) = gethostbyname('localhost');
($name, $aliases,$type,$len,$remote) = gethostbyname($host);

# 3. Se empaquetan las direcciones en el formato requerido
$sockaddr = 'S n a4 x8';
$localaddr  = pack($sockaddr, AF_INET, 0, $local);
$remoteaddr = pack($sockaddr, AF_INET, $port, $remote);

# 4. Se asocia el socket y se conecta con la direccion dada
bind(S, $localaddr) || die "bind: $!";
print "Intentando conectarme a $host por el puerto $port\n";
connect(S, $remoteaddr) || die "connect: $!";

# 5. Se recibe del socket y se escribe los resultados
while (defined($line = <S>))
{
   print $line;
}

# Finalmente se cierra el socket
close(S) || die "close: $!";
exit;
