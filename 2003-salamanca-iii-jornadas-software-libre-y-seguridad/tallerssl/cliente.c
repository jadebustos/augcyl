#include <openssl/ssl.h>
#include <stdio.h>

int main() {

  SSL_CTX *contexto=NULL; // en este objeto va la configuración SSL de la
  			  // aplicación, por ejemplo el caché de sesiones
  SSL *conexion=NULL; // una conexión SSL puede reutilizarse en más de una TCP
  BIO *bio=NULL; // Los objetos BIO son la E/S multiplataforma de OpenSSL	
                 // también se puede crear un objeto en OpenSSL con sockets en
                 // lugar de con objetos BIO, utilizando SSL_set_fd, pero esto
                 // ya es dependiente de la plataforma.
 
  const char * peticion="HEAD /index.html HTTP/1.0\n\n";
  char buffer[1024];
  int leidos;

  /* Cargamos mensajes de error */
  SSL_load_error_strings(); // Obtenemos cadena de error con funciones como
                            // ERR_reason_error_string(ERR_get_error());
                            // man err

  /* Inicializamos la librería */
  SSL_library_init();

  /* Creamos contexto */
  contexto=SSL_CTX_new(SSLv23_client_method());
  if (contexto==NULL) {
	  ERR_print_errors_fp(stderr);
	  exit(-1);
  }	  

  /* queremos tener caché de sesiones */
  //SSL_CTX_set_session_cache_mode(contexto,SSL_SESS_CACHE_CLIENT);
		  
  /* Creamos conexión */
  bio=BIO_new_connect("127.0.0.1:443");
  if (bio==NULL) {
	  ERR_print_errors_fp(stderr);
	  exit(-1);
  }
  conexion=SSL_new(contexto);
  if (conexion==NULL) {
    fprintf(stderr,"new");
    exit(-1);
  }
  SSL_set_bio(conexion,bio,bio);
  if (SSL_connect(conexion)==-1) {
	  ERR_print_errors_fp(stderr);
	  exit(-1);
  }

  /* enviamos la petición */
  printf("Resultado de escribir: %d\n",SSL_write(conexion,peticion,strlen(peticion)));

  /* leemos la respuesta */
  while ((leidos=SSL_read(conexion,buffer,1024))>0)
    write(1,buffer,leidos);

  /* cerramos la conexión */
  SSL_shutdown(conexion);

  /* nos preparamos para hacer otra, conservando todo lo demás */
  SSL_clear(conexion);
  BIO_reset(bio);
  
  //conexion=SSL_new(contexto);
  SSL_set_bio(conexion,bio,bio);

  printf("Resultado %d\n",SSL_connect(conexion));
  /* enviamos la petición */
  printf("Resultado de escribir: %d\n",SSL_write(conexion,peticion,strlen(peticion)));

  /* leemos la respuesta */
  while ((leidos=SSL_read(conexion,buffer,1024))>0)
    write(1,buffer,leidos);

  /* cerramos la conexión */
  SSL_shutdown(conexion);

}
