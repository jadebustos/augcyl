#!/usr/bin/perl -w

use Gtk;         # cargamos el modulo Gtk  

init Gtk;        # Inicializa Gtk-Perl

# Definicion de variables muy utilizadas  
my $false = 0;
my $true = 1;

my $window = new Gtk::Window( "toplevel" );
$window->set_title ("Calculadora");
$window->set_position("center");
$window->set_policy($false,$false,$true);	# No se puede maximizar
$window->signal_connect( "delete_event", \&CloseAppWindow );   

my $fixed = new Gtk::Fixed();
$fixed->set_usize(210,250);

creaBotones();
$Display = new Gtk::Entry();
$Display->set_text('0');
$displayStatus = 'RESULTS';
$Display->set_usize(190,25);
$fixed->put($Display,10,10);
$Display->show();

# Entramos en el bucle Gtk de eventos
$window->add($fixed);
$fixed->show();
$window->show();
main Gtk;

# Aqui nunca llegamos  
exit( 0 );

#-----------------------------------------------------------------------------
# 	Varias rutinas para hacer mas legible el codigo
#-----------------------------------------------------------------------------

sub creaBotones
{
# El boton del 1
$bt1 = new Gtk::Button("1");
$bt1->set_usize(40,40);
$bt1->signal_connect("clicked", \&add, ("1"));
$fixed->put($bt1,10,50);
$bt1->show();

# El boton del 2
$bt2 = new Gtk::Button("2");
$bt2->set_usize(40,40);
$bt2->signal_connect("clicked", \&add, ("2"));
$fixed->put($bt2,60,50);
$bt2->show();

# El boton del 3
$bt3 = new Gtk::Button("3");
$bt3->set_usize(40,40);
$bt3->signal_connect("clicked", \&add, ("3"));
$fixed->put($bt3,110,50);
$bt3->show();

# El boton del 4
$bt4 = new Gtk::Button("4");
$bt4->set_usize(40,40);
$bt4->signal_connect("clicked", \&add, ("4"));
$fixed->put($bt4,10,100);
$bt4->show();

# El boton del 5
$bt5 = new Gtk::Button("5");
$bt5->set_usize(40,40);
$bt5->signal_connect("clicked", \&add, ("5"));
$fixed->put($bt5,60,100);
$bt5->show();

# El boton del 6
$bt6 = new Gtk::Button("6");
$bt6->set_usize(40,40);
$bt6->signal_connect("clicked", \&add, ("6"));
$fixed->put($bt6,110,100);
$bt6->show();

# El boton del 7
$bt7 = new Gtk::Button("7");
$bt7->set_usize(40,40);
$bt7->signal_connect("clicked", \&add, ("7"));
$fixed->put($bt7,10,150);
$bt7->show();

# El boton del 8
$bt8 = new Gtk::Button("8");
$bt8->set_usize(40,40);
$bt8->signal_connect("clicked", \&add, ("8"));
$fixed->put($bt8,60,150);
$bt8->show();

# El boton del 9
$bt9 = new Gtk::Button("9");
$bt9->set_usize(40,40);
$bt9->signal_connect("clicked", \&add, ("9"));
$fixed->put($bt9,110,150);
$bt9->show();

# El boton del 0
$bt0 = new Gtk::Button("0");
$bt0->set_usize(40,40);
$bt0->signal_connect("clicked", \&add, ("0"));
$fixed->put($bt0,10,200);
$bt0->show();

# El boton del =
$bti = new Gtk::Button("=");
$bti->set_usize(40,40);
$bti->signal_connect("clicked", \&calculate, (" = "));
$fixed->put($bti,60,200);
$bti->show();

# El boton del Del
$btb = new Gtk::Button("Del");
$btb->signal_connect("clicked", 
   sub { $displayStatus = 'RESULTS'; $Display->set_text('');});
$btb->set_usize(40,40);
$fixed->put($btb,110,200);
$btb->show();

# Las operaciones
# El boton de la suma
$btSum = new Gtk::Button("+");
$btSum->set_usize(40,40);
$btSum->signal_connect("clicked", \&add, (" + "));
$fixed->put($btSum,160,50);
$btSum->show();
# El boton de la resta
$btRes = new Gtk::Button("-");
$btRes->set_usize(40,40);
$btRes->signal_connect("clicked", \&add, (" - "));
$fixed->put($btRes,160,100);
$btRes->show();
# El boton de la Multiplicacion
$btMul = new Gtk::Button("*");
$btMul->set_usize(40,40);
$btMul->signal_connect("clicked", \&add, (" * "));
$fixed->put($btMul,160,150);
$btMul->show();
# El boton de la Division
$btDiv = new Gtk::Button("/");
$btDiv->set_usize(40,40);
$btDiv->signal_connect("clicked", \&add, (" / "));
$fixed->put($btDiv,160,200);
$btDiv->show();
}

#----------------------------------------------------------------------------

sub CloseAppWindow
### Manejador del evento borrar 
{
   Gtk->exit( 0 );
   return $false;
}

#----------------------------------------------------------------------------

sub add
# Se encarga de la accion de añadir texto al entry como respuesta a la
# pulsacion de una tecla
{
   my ($widget, $data) = @_;
   if($displayStatus eq 'RESULTS')
   {
      # Se mostraban los resultados y se va a hacer un nuevo calculo
      if($data eq ' + ' || $data eq ' - ' || 
	 $data eq ' * ' || $data eq ' / ')
      {
         $Display->set_text ('0');	
      }
      else
      {
         $Display->set_text ('');	
      }
      $displayStatus = 'CLEAR';
      $Display->append_text($data);
   }
   elsif($displayStatus eq 'CLEAR')
   {
      $Display->append_text($data);
   }
}

#----------------------------------------------------------------------------

sub calculate
# Subrutina que realiza los calculos del texto del entry. Constituye un parser
# muy sencillo
{
   my $error = 0;

   if($displayStatus eq 'CLEAR')
   {
      $displayStatus = 'RESULTS';
      my ($widget, $data) = @_;
      $Display->append_text($data);
      # Procesamos el $Display
      @tokens = split(/ /,$Display->get_text());
      # Buscamos segun una preferencia dada
      while($tokens[1] ne '=')
      {
         for($i=0; $i<$#tokens; $i++)
         {
            if($tokens[$i] eq '/')
            {
	       if($tokens[$i+1] != 0)
	       {
                  $parcial = int($tokens[$i-1] / $tokens[$i+1]);
                  splice(@tokens,$i-1,3,($parcial));
	          next;
	       }
	       else
	       {
		  $tokens[1] = '=';
		  $error = 1;
		  last;
	       }
            }
         }
         for($i=0; $i<$#tokens; $i++)
         {
            if($tokens[$i] eq '*')
            {
               $parcial = $tokens[$i-1] * $tokens[$i+1];
    	       splice(@tokens,$i-1,3,($parcial));
	       next;
            }
         } 
         for($i=0; $i<$#tokens; $i++)
         {
            if($tokens[$i] eq '-')
            {
               $parcial = $tokens[$i-1] - $tokens[$i+1];
 	       splice(@tokens,$i-1,3,($parcial));
	       next;
            }
         }
         for($i=0; $i<$#tokens; $i++)
         {
            if($tokens[$i] eq '+')
            {
               $parcial = $tokens[$i-1] + $tokens[$i+1];
 	       splice(@tokens,$i-1,3,($parcial));
	       next;
            }
         }
      }
      if($error == 1)
      {
         $Display->set_text('ERR');
      }
      else
      {
         $Display->append_text("$tokens[0]");
      }
   }
}

#----------------------------------------------------------------------------
