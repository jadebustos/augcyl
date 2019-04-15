#!/usr/bin/perl -w

use Gtk;         
init Gtk; 

my $false = 0;
my $true = 1;

# Creamos la ventana principal
my $window = new Gtk::Window( "toplevel" );
$window->set_title ("Ejemplo con menus");
$window->set_position("center");
$window->set_policy($false,$false,$true);	
$window->signal_connect( "delete_event", sub { Gtk->exit(0); } );   

# Creamos la rejilla
my $fixed = new Gtk::Fixed();
$fixed->set_usize(350,250);

my $menubar = new Gtk::MenuBar();
$fixed->put($menubar,0,0);

# Creamos el menu 1 con dos Items colgando de el
my $menu1 = new Gtk::MenuItem("Menu1");
   my $mn1 = new Gtk::Menu();
      $mn1it1 = new Gtk::MenuItem("Item1");
      $mn1it1->signal_connect( 'activate', 
	sub { print "Se presiono el item 1 del menu 1\n"; } );
      $mn1->append($mn1it1);
      $mn1it2 = new Gtk::MenuItem("Item2");
      $mn1it2->signal_connect( 'activate', 
	sub { print "Se presiono el item 2 del menu 1\n"; } );
      $mn1->append($mn1it2);
   $menu1->set_submenu($mn1);
$menubar->append($menu1);



# Creamos el menu 2 con dos Items colgando de el
my $menu2 = new Gtk::MenuItem("Menu2");
   my $mn2 = new Gtk::Menu();
      $mn2it1 = new Gtk::MenuItem("Item1");
      $mn2it1->signal_connect( 'activate', 
	sub { print "Se presiono el item 1 del menu 2\n"; } );
      $mn2->append($mn2it1);
      $mn2it2 = new Gtk::MenuItem("Item2");
      $mn2it2->signal_connect( 'activate', 
	sub { print "Se presiono el item 2 del menu 2\n"; } );
      $mn2->append($mn2it2);
   $menu2->set_submenu($mn2);
$menubar->append($menu2);

# Visualizamos los menus
$menu1->show();
   $mn1it1->show();
   $mn1it2->show();
$menu2->show();
   $mn2it1->show();
   $mn2it2->show();
$menubar->show();


# Añadimos la rejilla y visualizamos todo
$window->add($fixed);
$fixed->show();
$window->show();
main Gtk;
