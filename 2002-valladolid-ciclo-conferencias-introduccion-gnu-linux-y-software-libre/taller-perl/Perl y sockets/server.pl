#!/usr/bin/perl -w
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

# Modelo de servidor 

use Socket;

$port = $ARGV[0];

# 1. Creamos el tipo de socket TCP. Si no nos sabemos el numero del TCP lo
# podemos preguntar con la siguiente funcion
$proto = getprotobyname('tcp');
socket(S,AF_INET,SOCK_STREAM,$proto) || die "socket: $!";   # $!(tipo de error)
print "Creacion del socket del lado del servidor.\n";

# 2. Se empaquetan las direcciones local y remota en el formato que piden
# la funcion bind y la funcion connect. Si para el host se dio su nombre
# en vez de su IP habra que obtener su IP con la funcion gethostbyname
($name, $aliases,$type,$len,$local) = gethostbyname('localhost');

# 3. Se empaquetan las direcciones en el formato requerido
$sockaddr = 'S n a4 x8';
$localaddr  = pack($sockaddr, AF_INET, $port, $local);

# 4. Se asocia el socket 
bind(S, $localaddr) || die "bind: $!";
listen(S,10) || die "listen: $!";
print "Servidor escuchando en el puerto $port...\n";

# 5. Se acepta una conexion de un cliente y se cambia de socket para atenderla
$clientaddr = accept(C,S) || die "accept: $!";

# 6. Desempaquetamos la direccion del cliente que llama
($family, $port, $ip) = unpack($sockaddr,$clientaddr);
$ip = gethostbyaddr($ip,AF_INET);
print "Aceptada conexion del cliente $ip por el puerto $port\n";

# 7. Le mandamos nuestro servicio
$hora = gmtime;
print C "La hora actual es: $hora\n";

# Finalmente se cierra el socket
close(C) || die "close: $!";
close(S) || die "close: $!";
exit;

