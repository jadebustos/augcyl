#!/usr/bin/perl -w -I/home/infos/mariari/libs/lib/site_perl/5.6.0/i386-linux/

#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU Library General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

use Gtk;         # Cargamos las librerias 

set_locale Gtk;  # Iniciamos los locales
init Gtk;        # Iniciamos las librerias

my $falso = 0;      # Para simplificar
my $verdadero = 1;



# Crear la ventana
my $ventana = new Gtk::Window( "toplevel" );  # Tipos de ventana

$ventana->set_default_size( 325, 100 );       # Dimensiones
$ventana->border_width(10);                   # Espacio entre elementos y borde de la ventana
$ventana->set_title( "Ejemplo Gtk, AUGCyL 2002" );      # Establecer el título

$ventana->signal_connect( "delete_event", \&Salir );    # Conectar evento con función



# Caja vertical
my $cajav = new Gtk::VBox( $falso, 5 );   # VBox ( homogeneo, separacion )
$ventana->add( $cajav );          # Añadir a la ventana
$cajav->show();                   # Mostrarlo



# Caja horizontal
my $etiqueta = new Gtk::Label("Etiqueta"); 
           # Crear etiqueta con ese texto
$cajav->pack_start($etiqueta, $verdadero,$verdadero,0);
           # pack_start ( widget, expandir, rellenar, espaciado )
$etiqueta->show();



# Crear entrada de texto

my $entrada = new Gtk::Entry( 50 );  # Maximo tamaño en nº caracteres

$entrada->set_text( "Bienvenido" );  # Establecer texto
$entrada->append_text( " a gtk." );   # Añadir texto al final

$entrada->signal_connect( "activate", \&poner_en_etiqueta );
	# evento activate: pulsación de intro
	# evento changed: cambia el contenido
$cajav->pack_start( $entrada, $verdadero, $verdadero, 0 ); #Añadir a la caja
$entrada->show();

# Creamos una caja horizontal
my $cajah = new Gtk::HBox( $falso, 0 );  # Caja horizontal
$cajav->pack_start( $cajah,$falso,$falso,0);
$cajah->show();

# Crear la selección de opción editable
my $editable = new Gtk::CheckButton( "Editable" );
$cajah->pack_start( $editable, $verdadero, $verdadero, 0 );
$editable->set_active( $verdadero ); # Indicamos si esta activo por defecto

$editable->signal_connect( "toggled", \&entrada_editable );
  # Cambia de estado
$editable->show();

# Crear la selección de opción visible
my $visible = new Gtk::CheckButton( "Visible" );
$cajah->pack_start( $visible, $verdadero, $verdadero, 0 );
$visible->signal_connect( "toggled", \&entrada_visible );
$visible->set_active( $verdadero );
$visible->show();

# Crear el boton para poner en la etiqueta
my $boton = new Gtk::Button( "Poner" );
$boton->signal_connect( "clicked", \&poner_en_etiqueta );
$cajav->pack_start( $boton, $falso, $falso, 0 );
$boton->show();

$ventana->show();

main Gtk;   # Bucle principal




### Funciones 

# Establecemos la opcion editable 

sub entrada_editable
{
   $entrada_editable= $editable->active;
   $entrada->set_editable( $entrada_editable );
}


# Establecemos la visibilidad de la entrada 

sub entrada_visible
{
   my $entrada_visible=$visible->active;
   $entrada->set_visibility( $entrada_visible );
}

sub poner_en_etiqueta
{
  my $cadena= $entrada->get_text(); # obtener texto de $entrada
#  $cadena=~tr/aeiou/uioea/;   # Intercambio de vocales
#  $cadena=~s/[aeio]/u/g;      # Vocales a una sola
  $etiqueta->set_text($cadena);     # Ponerlo
}

sub Salir
{
  print "Saliendo\n";  # Podemos mostrar en cualquier momento en la consola
  Gtk->exit(0);
}
