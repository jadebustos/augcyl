#!/usr/bin/perl -w

use Gtk;         # cargamos el modulo Gtk  

init Gtk;        # Inicializa Gtk-Perl

# Definicion de variables muy utilizadas  
my $false = 0;
my $true = 1;

# Creamos un widget ventana y un widget boton
my $window = new Gtk::Window( "toplevel" );
my $button = new Gtk::Button( "Hola Mundo!" );

# Registramos los manejadores de eventos
  # El evento de borrar la ventana (p.e. apretando a la x)
  $window->signal_connect( "delete_event", \&CloseAppWindow );   
  # El evento de apretar el boton
  $button->signal_connect( "clicked", \&SayHelloWorld );

# Mostramos el boton
$button->show();

# Fijamos ciertos atributos de la ventana, anclamos el boton a ella y la
# mostramos
$window->border_width( 15 );
$window->add( $button );
$window->show();

# Entramos en el bucle Gtk de eventos
main Gtk;

# Aqui nunca llegamos  
exit( 0 );



### Manejador del evento borrar 
sub CloseAppWindow
  {
    Gtk->exit( 0 );
    return $false;
  }

### Manejador del evento click
sub SayHelloWorld 
  {
    print "Hola mundo desde GTK!\n";
    return $false;
  }
