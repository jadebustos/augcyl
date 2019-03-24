#!/usr/bin/perl -I/home/infos/mariari/libs/lib/site_perl/5.6.0/i386-linux/

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


#Gtk...
use Gtk;
use IO::Socket;
use File::Basename;

set_locale Gtk;
init Gtk;
my $false=0;
my $true=1;

#Variables globales:
$socket=0;
$conectado=0;
$titulo="";
$functrespuesta="";
$server="";
$nick="";
$dentro=0;
$away=0;
%atitulo=();
%listadenicks=();
%names=();    #Si en un canal estamos al inicio del NAMES (0) o dentro (1)
$buffer="";
$timer=0;
%linescr=();
$debugmode=1;
$puertolocal=0;
$hostlocal="";
$iplocal="";
$apagar=0;
$SIG{"CHLD"}='IGNORE';

if ($debugmode)
  {
    $^W=1;
  }
else
  {
    $^W=0;
  }
#Socket unix para el applet

#unlink "/tmp/ircsock";
#$applet = IO::Socket::UNIX->new(Local => "/tmp/ircsock",
#				Type => SOCK_STREAM,
#				Listen => 1)
#	or die ("No se pudo abrir el socket unix: $@\n");


#COLORES

$cmap = Gtk::Gdk::Colormap->get_system();

&configdefecto;
&cargarconfig;

$rojo->{'red'}=0x9999;
$rojo->{'green'}=0;
$rojo->{'blue'}=0;
$cmap->color_alloc( $rojo );

$verde->{'red'}=0;
$verde->{'green'}=0x5555;
$verde->{'blue'}=0;
$cmap->color_alloc( $verde );

$azul->{'red'}=0;
$azul->{'green'}=0;
$azul->{'blue'}=0xFFFF;
$cmap->color_alloc( $azul );


#ventana nueva
$guin=new Gtk::Window("toplevel");
$guin->set_title("McK-IRC");
$main::titulo="McK-IRC";
$guin->signal_connect("delete_event", \&apagar,"Saliendo de McK-IRC\n");
$guin->set_default_size(600,400);

$linescr{general}=[];

$notebook=new Gtk::Notebook();
$notebook->set_tab_pos("bottom");
$notebook->set_scrollable($true);

$statusbar=new Gtk::Entry(100);
$statusbar->set_editable($false);


$winbox=new Gtk::VBox($false,1);

$winbox->pack_start($notebook,$true,$true,0);
$winbox->pack_start( $statusbar, $false, $false, 0 );
$statusbar->show();
$winbox->show();
$guin->add($winbox);


%ventanas=();
$ventanas{general}=Ventana->new("General");

$guin->show_all();
$dialog=new Dialogo($config{nick},$config{server});

main Gtk;



#Funciones:

sub conectar {
      local $serv=shift;
      local $puerto=shift;
      if ($conectado) 
         {
	    close($socket);
	    $conectado=0;
	    $guin->set_title("McK-IRC");
	    $titulo="McK-IRC";
	 }
      print "Conectando...\n";
      $socket=IO::Socket::INET->new(PeerAddr => $serv,
                                    PeerPort => $puerto,
	                            Proto => "tcp",
	                            Type => SOCK_STREAM)
	            or die "No se pudo conectar al socket: $@\n";
      $socket->autoflush(1);
      $guin->set_title("McK-IRC / Conectado a $serv");
      $titulo="McK-IRC / Conectado a $serv";
      my $mysockaddr = getsockname($socket);
      my ($port,$myaddr) = sockaddr_in($mysockaddr);
      $puertolocal=$port;
      $hostlocal= scalar gethostbyaddr($myaddr, AF_INET);
      $iplocal=inet_ntoa($myaddr);
      $server=$serv;
      $conectado=1;
      print "Conectado a $server, puerto $puerto";
      if ($debugmode) { print " desde $hostlocal ($iplocal) puerto $puertolocal.\n"; }
      else { print ".\n";}
      $ircserversock=Gtk::Gdk->input_add(fileno($socket),"read",\&seleccionarentrada);
      #$appletsock=Gtk::Gdk->input_add(fileno($applet),"read",\&respuestapplet);
	     }
sub cargarconfig
  {
       my $confignombre="$ENV{HOME}/.mckirc";
       if (-e $confignombre)
         {
            open CONFIG,"$confignombre";
            my @datos=<CONFIG>;
            close CONFIG;
            @datos= grep { $_!~/^#/} @datos;
            foreach my $line (@datos)
             {
                 $line=~s/#.*//;
                 my ($clave,$valor) = split /=/,$line;
                 $clave=~s/^\s+//;
                 $valor=~s/^\s+//;
                 $clave=~s/\s+$//;
                 $valor=~s/\s+$//;
                 $config{$clave}=$valor;
             }
         }
   }

sub configdefecto
   {
       $config{nick}=$ENV{LOGNAME};
       $config{server}="irc.openprojects.net";
       $config{JOIN}="%n ha entrado en %c.";
       $config{Titulo}=1;
   }

sub guardarconfig
   {
       open CONF,">$ENV{HOME}/.mckirc";
       foreach my $clave (sort keys %config)
         {
	    print CONF "$clave = $config{$clave}\n";
	 }
       close CONF;
       chmod 0600,"$ENV{HOME}/.mckirc";
   }
   
sub respuestapplet
   {
     my ($origen,$condicion)=@_;
   }
																      
sub respondeping {
      my $entrada=shift(@_);
      my $devolv=0;
      if ($entrada=~/PING :(.+)/)
         {
              enviar("PONG :$1\n");
	      $devolv=1;
         }
      elsif ($entrada=~/pong ([^ ]+)/)
         {
	      enviar("PONG :$1\n");
	 }			
      else { $devolv=0; }
      return $devolv; 
    }

sub registranick {
      my $nic=shift;
      my $usr=shift;
      enviar("NICK $nic\n");
      enviar("USER $usr 0 * :usuario\n");
      $nick=$nic;
       }
							        
sub entrarcanal {
      my $canal=shift(@_);
      unless (exists $ventanas{lc($canal)}) 
	{ 
         $ventanas{lc ($canal)}=Ventana->new($canal);
         enviar("JOIN $canal\n");
	 $atitulo{$canal}=$config{Titulo};
	 my @lineas=();
	 enviar("TOPIC $canal\n");
#	 enviar("NAMES $canal\n");
	}
                 }


sub procesairc {
     local $line=shift(@_);
     my $devolv=1;
     if ($line=~/:([^!]*)!([^\@]*)\@[^ ]* PRIVMSG (#[^ ]*) :(.*)$/)
          {
	     my $nick=$1;
	     my $user=$2;
	     my $canal=($3);
	     my $mensaje=$4;
	     my $msgtemp=$4;
	     if ($msgtemp=~/\001ACTION (.*)\001/)
	        {
		    $ventanas{lc($canal)}->escribir("   *$nick $1\n",$rojo);
#                    $ventanas{lc($canal)}->escribir("$1\n",undef);
		    $guin->set_title(substr "**$nick/$canal $mensaje",0,$longtit) if $atitulo{$canal};
		}
	     else 
	        {
	             unless (exists ($ventanas{lc($canal)})) 
                       {
	                   $ventanas{lc($canal)}=Ventana->new($canal);
              	       }
           	     $ventanas{lc($canal)}->escribir("<$nick>   ",$azul);
              	     $ventanas{lc($canal)}->escribir("$mensaje\n",undef);
		    $guin->set_title(substr "$titulo - <$nick/$canal> $mensaje",0,$longtit) if $atitulo{$canal};

		}
	  }
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* PRIVMSG ([^ ]*) :(.*)/)
          {
		my $nick=$1;
		my $mensaje=$4;
		if ($mensaje=~/\001VERSION(.*)\001/i) 
		  {
		    $ventanas{general}->escribir("**Recibido ctcp VERSION de $nick.\n",$verde);
		    $statusbar->set_text("Recibido ctcp VERSION de $nick.");
		    my $uname=`uname -a`;
		    @auname=split ' ',$uname;
		    my $SO=$auname[0];
		    my $kernel=$auname[2];
		    my $arch=$auname[10];
		    my $mhz=`cat /proc/cpuinfo|grep MHz`;
		    $mhz=~/: (.+)$/;
		    $MHz=$1;
		    enviar("NOTICE $nick :\001VERSION McK-IRC 0.1 $SO $kernel [$arch/$MHz]\001\n");
                  }
		elsif ($mensaje=~/\001ACTION (.*)\001/)
                  {
                    $ventanas{lc($3)}->escribir("\t*$nick $1\n",$rojo);
#                    $ventanas{lc($3)}->escribir("$1\n",undef);
                  }
		elsif ($mensaje=~/\001DCC.*\001/)
		  {
		    recibedcc($line);
		  }
		else
		 {
	  	    unless (exists $ventanas{lc($1)})
		     {
		       $ventanas{lc($1)}=Ventana->new($1);
		       $ventanas{lc($1)}->escribirtopic("Conversación con $1.");
		       $ventanas{lc($1)}->{topic}->set_editable($false);
		     }
		    $ventanas{lc($1)}->escribir("<$1>\t",$azul);
                    $ventanas{lc($1)}->escribir("$4\n",undef);
		 }
	  }
#  :NickServ!NickServ@services. NOTICE McK :If this is your nickname, type /msg NickServ IDENTIFY <password>
     elsif ($line=~/:NickServ!NickServ\@services\. NOTICE ([^ ]+) :If this is your nickname, type \/msg NickServ .IDENTIFY. <password>/)
       {
          enviar("PRIVMSG nickserv :identify $config{clave}\n") if ($config{clave});
	  $statusbar->set_text("Se ha pedido contraseña para el nick \"$1\".");
	  $ventanas{general}->escribir("Se ha pedido contraseña para el nick \"$1\".\n",$verde);
       }
#<:NickServ!NickServ@services. NOTICE McK :If this is your nickname, type /msg NickServ IDENTIFY <password>
     elsif ($line=~/:NickServ!NickServ\@services\. NOTICE McK :Password accepted - you are now recognized/)
       {
          $statusbar->set_text("Ya has sido identificado correctamente");
	  $ventanas{general}->escribir("Ya has sido identificado correctamente\n");
       }
	  
#<:NickServ!NickServ@services. NOTICE McK :Password accepted - you are now recognized
#  :ChanServ!ChanServ@services. NOTICE McK :You do not have AutoOp access to [#pucelawireless]
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* NOTICE ([^ ]*) :(.*)/)
          {
	    $ventanas{general}->escribir("[NOTICE] ",$rojo);
	    $ventanas{general}->escribir("de ");
	    $ventanas{general}->escribir("$1",$azul);
	    $ventanas{general}->escribir(": $4\n");
	    $statusbar->set_text("[NOTICE] de $1: $4");
	  }
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* JOIN :(#.*$)/)
          {
	     $statusbar->set_text("--> $1 se une a la conversación en $3.");
#	     push (@{$listadenicks{$3}},$1);
#	     print "Tras join: @{$listadenicks{$3}}\n";
#	     $ventanas{$3}->mostrarnicks();
	     if ($1 ne $nick)
	      {
	     push @{$listadenicks{$3}},$1;
	     &Ventana::eliminaymuestranicks($ventanas{lc($3)});
	      }
#	     enviar("NAMES $3\n") if ($1 ne $nick);
	  }
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* PART (#[^ ]+) ?:?(.*)/) 
            {
	     $ventanas{lc($3)}->escribir("<-- $1 abandona la conversación en $3: $4 \n",$verde) if ($ventanas{lc($3)});
	     $statusbar->set_text("<-- $1 abandona la conversación en $3: $4");
#	     @{$listadenicks{$3}} = grep { $_ ne "$1" } @{$listadenicks{$3}};
#	     print "tras PART: @{$listadenicks{$3}}\n";
#	     @ventanas{$3}->mostrarnicks();
	     if ($1 ne $nick)
	      {
#	     @{$listadenicks{$3}};	
	     @{$listadenicks{$3}} = grep { $_ ne $1 } @{$listadenicks{$3}};
	     &Ventana::eliminaymuestranicks($ventanas{lc($3)});
	      }
#	     if ($1 ne $nick) {enviar("NAMES $3\n");}
            }
# :T_Machine!~matrix@213-97-255-137.uc.nombres.ttd.es QUIT :[totalmente busy]
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* QUIT :(.*)/) 
            {
	     foreach my $page (values %ventanas)
	       {
	         if (grep {$_ eq $1} @{$listadenicks{$page->{canal}}})
		  {
	          $ventanas{lc($page->{canal})}->escribir("<-- $1 abandona la conversación, $3 \n",$verde) if ($page->{canal} ne 'General');
		  
	     $statusbar->set_text("<-- $1 abandona la conversación, $3");
	            if ($1 ne $nick)
	              {
	              @{$listadenicks{$page->{canal}}};   
                      @{$listadenicks{$page->{canal}}} = grep { $_ ne $1 } @{$listadenicks{$page->{canal}}};
                      &Ventana::eliminaymuestranicks($ventanas{lc($page->{canal})});
	              }
		  }
	       }
            }
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* KICK (#[^ ]+) ([^ ]+) :(.*)/)
        {
	  my $razon="";
	  $razon=", ($5)" if ($5);
	  if ($4 eq $nick) {
#		 open (FILTMP,">/tmp/$3log");
#		 my @datos=$ventanas{$3}->{text}->get_text();
#		 print FILTMP "@datos\n";
#		 close(FILTMP);
		 &Ventana::eliminar(undef,$ventanas{lc($3)}) if (exists $ventanas{lc($3)});
		 $ventanas{general}->escribir("**Has sido expulsado de $3 por $1$razon.\n");
	         $statusbar->set_text("Has sido expulsado de $3 por $1$razon.");
#		 Un log con la conversación ha sido guardado en /tmp/$3log\n",$verde);
		 }
	  else
	    {
   	        $ventanas{lc($3)}->escribir("** $1 echa a $4 del canal $3$razon.\n",$verde);
		$statusbar->set_text("** $1 echa a $4 del canal $3$razon");
#		@{$listadenicks{$3}}=();
	        @{$listadenicks{$3}} = grep { $_ ne $1 } @{$listadenicks{$3}};
                &Ventana::eliminaymuestranicks($ventanas{lc($3)});
#		enviar("NAMES $3\n");
	     }
	}
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* MODE (#[^ ]+) ([\+|-])(.) (.+)/)
        {
	  my $canal=$3;
	  my $masmenos=$4;
	  my $letmodo=$5;
	  my $aquien=$6;
	  my $ponquit=($4 eq '+')?"añade":"quita";
	  my $modo;
	  if ($letmodo eq 'o') { $modo='modo op'; }
	  elsif($letmodo eq 'v') { $modo='voz'; }
	  elsif($letmodo eq 'b') { $modo='ban'; }
	  $ventanas{lc($canal)}->escribir("-- $1 $ponquit $modo a $6 en $canal.\n",$verde);
	  $statusbar->set_text("-- $1 $ponquit $modo a $6 en $canal.");
	  enviar("NAMES $canal\n");
	  #my $evalu='$_ =~/([@+])?$aquien/; $modoanterior=$1';
	  #my $modoanterior;
	  #my @listtmp=grep {eval $evalu } @{$listadenicks{$3}};
	  #my $nombre=shift @listtmp;
	  #print "\$1:$1\n";
	  #if ($masmenos eq '+')
	    #{
	        #if ($1 eq "@") { $nombre="\@$nombre"; }
	        #elsif($letmodo eq "o") { $nombre="\@$nombre"; }
	        #elsif($1 eq "" and $letmodo eq "v") { $nombre="+$nombre"; }
		
            #}
	  #elsif ($masmenos eq '-')
	    #{
		#enviar("NAMES $canal\n");
	    #}
	  #$evalu='$_ !~/[@+]?$aquien/';
	  #@{$listadenicks{$3}} = grep { eval $evalu  } @{$listadenicks{$3}};
	  #push @{$listadenicks{$3}},$nombre if ($nombre);
          #&Ventana::eliminaymuestranicks($ventanas{lc($canal)});
	  #print "lista cambiada: @{$listadenicks{$3}}\nnick: $nombre\n" if ($debugmode);

#	  @{$listadenicks{$3}}=();
#	   @{$listadenicks{$3}} = grep { $_ ne $1 } @{$listadenicks{$3}};
#         enviar("NAMES $3\n");
	}
     elsif ($line=~/:([^ ]+) 332 ([^ ]+) (#[^ ]+) :(.*)/)
        {
	  if ($4 ne "")
	     {
        	  $ventanas{lc($3)}->escribirtopic($4);
	     }
	  else 
	     {
	     	  $ventanas{lc($3)}->escribirtopic("No hay topic.");
	     }
	}
     elsif ($line=~/:([^!]*)!([^\@]*)\@[^ ]* TOPIC (#[^ ]+) :(.*)/)
        {
	  $ventanas{lc($3)}->escribirtopic($4);
	  $ventanas{lc($3)}->escribir("--$1 cambia el topic a: $4\n");
	  $statusbar->set_text("--$1 cambia el topic en $3 a: $4");
	}
     elsif ($line=~/:([^ ]+) 353 ([^ ]+) = (#[^ ]+) :(.*)/)
        {
	  my @listemp=split ' ',$4;
	  if (!$names{$3})
	     {
	       #print "Borrando \$names{$3} y poniendo lo nuevo.\n";
	       @{$listadenicks{$3}}=();
	       @{$listadenicks{$3}}=@listemp; 
	       $names{$3}=1;
	       $ventanas{lc($3)}->eliminaymuestranicks();
	       
	     }
	  else {
	      push @{$listadenicks{$3}},@listemp;
	      $ventanas{lc($3)}->mostrarnicks();
	      }
        }
#     :mckmachine.dhs.org 451 JOIN :You have not registered
     elsif ($line=~/:[^ ]+ 451 [^ ] :.*/)
        {
	 registrarnick($nick,$nick) if (defined $nick);
	}
     elsif ($line=~/:([^ ]+) 366 ([^ ]+) (#[^ ]+) :(.*)/)
        {
	  $names{$3}=0;
	}
     elsif ($line=~/:([^ ]+) 331 ([^ ]+) (#[^ ]+) :(.*)/)
        {
	  $ventanas{lc($3)}->escribirtopic("No hay topic indicado.");
	  $ventanas{lc($3)}->escribir("**No hay topic en el canal $3.\n",$verde);
	}
     elsif ($line=~/:([^ ]+) 306 ([^ ]+) :(.*)/)
        {
	   foreach my $vent (values %ventanas)
	     {
	          $vent->escribir("**Has sido marcado como away.\n",$verde);
		  $statusbar->set_text("**Has sido marcado como away.");
	     }
	   $away=1;
	}
     elsif ($line=~/:([^ ]+) 305 ([^ ]+) :(.*)/)
        {
	   foreach my $vent (values %ventanas)
	     {
	         $vent->escribir("**Ya no estas marcado como away.\n",$verde);
		 $statusbar->set_text("**Ya no estas marcado como away.");
             }
	   $away=0;
	}
     elsif ($line=~/:([^ ]+) 301 ([^ ]+) ([^ ]+) :(.*)/)
        {        #:mckmachine.dhs.org 301 McK SuNick :Estoy ocupado.
              unless (exists $ventanas{lc($3)})
                 {
	             $ventanas{lc($3)}=Ventana->new($3);
	             $ventanas{lc($3)}->escribirtopic("Conversación con $3.");
	             $ventanas{lc($3)}->{topic}->set_editable($false);
	         }
	      $ventanas{lc($3)}->escribir("[[ $3 ]] (away) => ",$azul);
	      $ventanas{lc($3)}->escribir("$4\n",undef);
	}   
#     :McK!~mck@rox-14131.dhs.org NICK :changed
#     :TiRi-DJ!~carlos@cable239a151.usuarios.retecal.es NICK :TiRi-OUT
     elsif ($line=~/:([^!]+)!([^\@]+)@([^ ]+) NICK :(.+)/)
        {
#          print "Llegado cambio de nick, \$1=$1, \$main::nick=$main::nick\n";
	   if ($1 eq $main::nick)
	      {
#	        print "Nick cambiado\n";
	        $main::nick=$4;
		foreach my $vent (values %ventanas)
		  {
		    $ventanas{general}->escribir("**Ahora te llamas $nick.\n",$verde);
                    $statusbar->set_text("Ahora te llamas $nick.");		 
		    $vent->{nick}->set_text("$nick  "); 
		  }
              }
	   my $can='';
	   foreach $can (keys %ventanas)
	    {
	       enviar("NAMES $can\n") if ($can ne "general");
	    }
	}
#     <:mckmachine.dhs.org 433 * SuNick :Nickname is already in use.
#<:mckmachine.dhs.org 433 SuNick McK :Nickname is already in use.
     elsif ($line=~/:([^ ]+) 433 ([^ ]+) ([^ ]+) :(.*)/)
        {
	   srand(time());
	   my $numal=int rand(8888)+1000;
	   my $nuevonick= "$3-$numal";
	   enviar("NICK $nuevonick\n");
	   $ventanas{general}->escribir("**El nick $3 estaba en uso, utilice /nick <otronick> para elegir un nuevo nick.\n",$verde);
	   $statusbar->set_text("El nick $3 estaba en uso, utilice /nick <otronick> para elegir un nuevo nick.");
	}
     elsif ($line=~/Found your hostname/)
        {
          registranick($nick,$nick) if (defined $nick);
          $dentro=1;
	  $devolv=0;
        }
#:Server.IRC.net 002 SuNick :Your host is Server.IRC.net, running version Unreal3.1.1-Darkshades+
     elsif ($line=~/:([^ ]+) 002 ([^ ]+) :Your host is ([^ ]+) (.*)/)
        {
          $guin->set_title("McK-IRC / Conectado a $1");
	  $titulo="McK-IRC / Conectado a $1";
        }
# :NickServ!NickServ@services. NOTICE McK :This nickname is owned by someone else
     else { $devolv=0;}
	  
     return $devolv; 
     }

sub seleccionarentrada
  {
     my ($origen,$condicion)=@_;
     if (my $leidos=sysread($socket,$data,2048))
      {
     $buffer.=$data;
     while ($buffer =~ s/^(.*)\n//c)
       {
	  $ent=$1;
          chomp($ent);
          chop($ent);
          if (respondeping($ent)) {}
          elsif ( procesairc($ent)) {}
          else { $ventanas{general}->escribir("$ent\n"); }
          print "<$ent\n" if ($debugmode);
       }
      }
     elsif ($apagar)
       {
          Gtk->exit(0);
       }
     else
       {
          print "El servidor cerro la conexion\n";
	  Gtk->exit(1);
       }
  }

 
  
sub comando
 {
    my $linea=shift(@_);
    my $canal=shift;
    @params=split(/[ ]+/,$linea);
    my $coman=$params[0];
    my $numparams=$#params;
    if ($coman eq "quit")
       {
	    $linea=~s/^quit//;
	    $linea=~s/^ *//;
	    my $despedida=($linea)?$linea:"Saliendo de McK-IRC";
	    apagar(undef,"$despedida\n");
       }
    elsif ($coman eq "leave")
       {
	$linea=~/leave #([^ ]+) (.*)/;
	if (exists $ventanas{lc($params[1])})
	  {
         	salircanal($params[1],$2);
	  }
	else
	  {
	    $ventanas{lc($canal)}->escribir("No esta conectado con $params[1].\n",$verde);
            $statusbar->set_text("No esta conectado con $params[1].");
	  }
       }
    elsif ($coman eq "join")
       {
           entrarcanal($params[1]);
       }
    elsif ($coman eq "server")
       {
       	 
	  $ventanas{general}->{text}->backward_delete( $ventanas{general}->{text}->get_length());
	  #$main::notebook->remove_page($numpag);
	  #delete($main::ventanas{general});
	  foreach $page (values %ventanas)
	    {
	    print "Eliminando ",$page->{canal},"\n" if ($debugmode);
	    &Ventana::eliminar(undef,$page) unless ($page->{canal} eq 'General');
	    }
	  if ($conectado)
	     {
	       close($socket);
	       $conectado=0;
	     }
	  my $puerto=$params[2];
	  $puerto||=6667;
	  my $server=$params[1];
	  $server||="irc.openprojects.net";
	  #print "Conectando\n";
	  conectar($server,$puerto);
       }	   
    elsif ($coman eq "j")
       {
       	   if($params[1]!~/#(.*)/)
	      {
	        $params[1]="#$params[1]";
	      }
	   entrarcanal($params[1]);
       }
    elsif ($coman eq "titulo")
       {
          if ($params[1] eq "on")
	    {
          $atitulo{$canal}=1;
	  $ventanas{general}->escribir("Ha puesto el canal $canal para mostrarlo en el titulo",$verde);
	  $statusbar->set_text("Ha puesto el canal $canal para mostrarlo en el titulo");
	    }
	  elsif ($params[1] eq "off")
	    {
	     delete $atitulo{$canal};
	     $guin->set_title("$titulo");
	  $ventanas{general}->escribir("Ha quitado el canal $canal para mostrarlo en el titulo",$verde);
	     $statusbar->set_text("Ha quitado el canal $canal para mostrarlo en el titulo");
	    }
       }
    elsif ($coman eq "set")
       {
          if ($params[1] && $params[2])
	     {
	       $config{$params[1]}=$params[2];
	     }
       }
    elsif ($coman eq "nick")
       {
	  if ($params[1])
	   {
	        my $nick=$params[1];
	        enviar("NICK $nick\n");
	   }
       }
    elsif ($coman eq "raw")
       {
	   $linea=~/raw (.+)/;
	   enviar("$1\n");
	   $ventanas{general}->escribir(">RAW<$1\n");
	   $ventanas{lc $canal}->escribir(">RAW<$1\n");
       }
    elsif (($coman eq "eval") && $debugmode)
       {
           $linea=~/eval (.+)/;
	   eval "$1";
	   $ventanas{general}->escribir(">eval<$1\n");
	   $ventanas{lc $canal}->escribir(">eval<$1\n");
       }
    elsif ($coman eq "msg")
       {
       	   $linea=~/msg\s+(\S+)\s+(.*)/;
	   enviar("PRIVMSG $1 :$2\n");
           unless (exists $ventanas{lc($1)})
                     {
                       $ventanas{lc($1)}=Ventana->new($1);
                       $ventanas{lc($1)}->escribirtopic("Conversación con $1.");
                       $ventanas{lc($1)}->{topic}->set_editable($false);
                     }
           $ventanas{lc($1)}->escribir("<$1>\t",$rojo);
           $ventanas{lc($1)}->escribir("$4\n",undef);
       }
    elsif ($coman eq "me")
       {
       	 $linea=~/me (.*)/;
	 enviar("PRIVMSG $canal :\01ACTION $1\01\n");
	 $ventanas{lc($canal)}->escribir("\t*$nick ",$rojo);
	 $ventanas{lc($canal)}->escribir("$1\n",undef);
       }
    elsif ($coman eq 'op')
       {
         if ($numparams == 1)
             {
               enviar("MODE $canal +o $params[1]\n");
             }
         elsif ($numparams == 2)
             {
               enviar("MODE $params[1] +o $params[2]\n");
             }
         
       } 
    elsif ($coman eq 'deop')
       {
         if ($numparams == 1)
             {
               enviar("MODE $canal -o $params[1]\n");
             }
         elsif ($numparams == 2)
             {
               enviar("MODE $params[1] -o $params[2]\n");
             }
       } 
    elsif ($coman eq 'voice')
       {
         if ($numparams == 1)
             {
               enviar("MODE $canal +v $params[1]\n");
             }
         elsif ($numparams == 2)
             {
               enviar("MODE $params[1] +v $params[2]\n");
             }
       }
    elsif ($coman eq 'devoice')
       {
         if ($numparams == 1)
             {
               enviar("MODE $canal -v $params[1]\n");
             }
         elsif ($numparams == 2)
             {
               enviar("MODE $params[1] -v $params[2]\n");
             }
       }
    elsif ($coman eq "kick")
       {
       	 $linea=~/^kick ([^ ]+)(.*)/;
	 my $quien=$1;
	 my $razon;
	 $razon = " :$2" if ($razon);
	 enviar("KICK $canal $1$razon\n");
       }
    elsif ($coman eq "topic")
       {
	 $linea=~/topic( (.*))?/;
	 my $datos=$2;
	 if ($1 eq "") {
	 	enviar("TOPIC $canal\n");
		}
	 else
	   {
	      enviar("TOPIC $canal :$datos\n");
	   }
       }
    elsif ($coman eq "ctcp")
       {
	   $linea=~/ctcp ([^ ]+) ([^ ]+)( .*?)?/;
	   my $coman=uc $2;
           enviar("PRIVMSG $1 :\01$coman$3\01\n");
       }
    elsif ($coman eq "whois")
       {
         enviar("WHOIS $params[1]\n");
       }
    elsif ($coman eq "whowas")
       {
       	 enviar("WHOWAS $params[1]\n");
       }
    elsif ($coman eq "query")
       {
         unless (exists $ventanas{lc($params[1])})
	   {
	     $ventanas{lc($params[1])}=Ventana->new($params[1]);
             $ventanas{lc($params[1])}->escribirtopic("Conversación con $1.");
	     $ventanas{lc($params[1])}->{topic}->set_editable($false);
	   }
       }
    elsif ($coman eq "away")
       {
          #$linea=~/away (.*?)?/;
	  my $mensaje;
	  ($mensaje) = $linea =~ /^away(.+)$/;
	  $mensaje=~s/^\s+//; 
	  if(!$away)
	    {
	       my $razon=($mensaje)?$mensaje:"Estoy ocupado.";
	       enviar("AWAY :$razon\n");
	    }
	  elsif ($away)
	    {
	       enviar("AWAY\n");
	    }
       }
    elsif ($coman eq "dcc")
      {
         enviadcc($params[1],$params[2],$params[3]);
      }
    else 
      {
              $ventanas{general}->escribir("**Comando no implementado.\n",$verde);
              $ventanas{lc $canal}->escribir("**Comando no implementado.\n",$verde);
	      $statusbar->set_text("Comando no implementado.");

      }
	
 }

sub procesar
   {
    my $this=shift;
    my $linea=shift;
    my $canal=$this->{canal};
    chomp($linea);
    $guin->set_title("$titulo");
    if ($linea=~m/^\/(.+)/) {
       comando($1,$canal);}
    elsif($canal=~/^#(.+)/) 
       {
       	  enviar("PRIVMSG $canal :$linea\n");
          $this->escribir("<$main::nick>   ",$rojo);
	  $this->escribir("$linea\n",undef);
       }
    elsif(lc($canal) ne "general")
       {
       	  enviar("PRIVMSG $canal :$linea\n");
          $this->escribir("<$main::nick>\t",$rojo);
	  $this->escribir("$linea\n",undef);
       }
   }


	
sub apagar{
	my $widget=shift;
	my $mensaje=shift;
	chomp $mensaje;
	&guardarconfig;
	$main::apagar=1;
	if ($conectado)
	  { 
	    $mensaje="McK-IRC saliendo." unless($mensaje);
	    enviar("QUIT :$mensaje\n");
          }
	#close($applet);  
#	Gtk->exit(0);	
	}
	
sub enviar {
   my $cadena=shift;
   open(F,">>/tmp/algo") if ($debugmode);
   print $socket "$cadena";
   print F "$cadena" if ($debugmode);
   close F if ($debugmode);
   print ">$cadena" if ($debugmode);
   }

sub salircanal{
   my $canal=shift;
   my $despedida=shift;
   my $desp= $despedida?" :$despedida":"";
   if ($canal=~/#.*/)
      {
         enviar("PART $canal$despedida\n");
      }
   &Ventana::eliminar(undef,$ventanas{lc($canal)}) if exists ($ventanas{lc($canal)});
   if (exists $ventanas{lc($canal)} )    {  delete($ventanas{lc($canal)});     }
   if (exists $listadenicks{$canal}) {  delete($listadenicks{$canal}); }
   if (exists $names{$canal})        {  delete($names{$canal});        }
     }

sub recibedcc
  {
 #:([^!]*)!([^\@]*)\@[^ ]* PRIVMSG ([^ ]*) :(.*)$
      my $linea=shift;
      $linea=~/:([^!]*)!([^\@]*)\@[^ ]* PRIVMSG ([^ ]*) :(.*)$/;
      my $nickorigen=$1;
      my $comando=$4;
      my $nombrearchivo;
      my $ip;
      my $puerto;
      my $tamanno;
      my $turbo;
      $comando=~s/\001//g;
      $comando=~s/^DCC\s*//;
      my $parametros=$comando;
      if ($parametros=~/^T?SEND/)
        {
	   $parametros=~/^T?SEND ([^ ]+) (\d+) (\d+) (\d+)/;  # SEND archivo ip puerto tamanno
	   $nombrearchivo=$1;
	   $ip=$ip=join '.', unpack 'C4', pack 'N', $2;
	   $puerto=$3;
	   $tamanno=$4;
	   if ($parametros=~/^TSEND/) { $turbo=1; }
	   elsif ($parametros=~/^SEND/){ $turbo=0; }
	   print "archivo: $nombrearchivo ip:$ip puerto:$puerto tamaño:$tamanno\n" if ($debugmode);
	   $ventanas{general}->escribir("Recibida propuesta de dcc de $nickorigen($ip), archivo = $nombrearchivo, tamaño: $tamanno\n",$verde);
	   $statusbar->set_text("Recibida propuesta de dcc de $nickorigen($ip), archivo = $nombrearchivo, tamaño: $tamanno");
	}
	my $pid;
	if (defined($pid=fork()))
	   {
	      if ($pid==0)
	       {
	         $dccrecv=IO::Socket::INET->new(PeerAddr => $ip,
		                               PeerPort => $puerto,
	                                       Proto => "tcp",
                                              Type => SOCK_STREAM)
		        or Gtk->_exit(1);
                $dccrecv->autoflush(1);
		my $buffer="";
		my $horainicio=time();
		my $transfer=0;
		my $tambuf=0;
		while($reci=sysread($dccrecv,$_,1024))
		   {
		     $buffer.=$_;
		     $tambuf=length($buffer);
		     print $dccrecv pack('N',$tambuf) if ($reci);
		     my $actual=time();
		     $transfer=(int($tambuf*100/($actual-$horainicio)/1024))/100 if ($actual-$horainicio);
		     print "Recibido: $tambuf de $tamanno; ultimo: $reci a $transfer KBytes/seg\n" if ($debugmode);
		     if ($tambuf eq $tamanno)
		       {
		         last;
		       }
		   }
		my $sufijo="";
		my $numsufijo=0;
		while (-e "$ENV{HOME}/$nombrearchivo$sufijo")
		  {
		     $numsufijo++;
		     $sufijo=".$numsufijo";
		  }
                if (length($buffer) != $tamanno)
		   {  print "Error en la transmisión," if ($debugmode); }
		else
		    { print "Finalizada la transmision," if ($debugmode); }

		print " guardando en $ENV{HOME}/$nombrearchivo$sufijo , ",length($buffer)," Bytes transmitidos en ",time()-$horainicio,"segundos.\n" if ($debugmode);
	        open(FDCC,">$ENV{HOME}/$nombrearchivo$sufijo");
        	binmode(FDCC);
		print FDCC "$buffer";
		close(FDCC);
		close($dccrecv);
	        Gtk->_exit(0);
	      }
	    }
	else
	  {
	     $ventanas{general}->escribir("**Fallo en fork()\n",$verde);
	  }
  }
      
sub enviadcc
  {
	 my ($tipo,$aquien,$archivo)=@_;
	 if ($tipo=~/t?send/)
	   {
	      my $tipodcc,$turbo;
	      if ($tipo eq 'send')
	          { $tipodcc='SEND';  $turbo=0;}
	      elsif ($tipo eq 'tsend')
	          {$tipodcc='TSEND';  $turbo=1;}
	      if (-e $archivo)
	        {
	      my $tamanno=(-s $archivo);
	      my $puerto=8787;
	      my $nomarchivo=basename($archivo);
	      my $dire=unpack("N",pack("CCCC",split /\./,$iplocal));
	      enviar("PRIVMSG $aquien :\001DCC $tipodcc $nomarchivo $dire $puerto $tamanno\001\n");
	      socketpair(CHILD, PARENT, AF_UNIX, SOCK_STREAM, PF_UNSPEC)
	                                             or  print "Error en socketpair: $!";
	      $ventanas{general}->escribir("Enviando el archivo $nomarchivo a $aquien.\n",$verde);
	      $statusbar->set_text("Enviando el archivo $nomarchivo a $aquien.");
	      CHILD->autoflush(1);
              PARENT->autoflush(1);
	      
	      if (defined($pid=fork()))
	        {
		  if ($pid==0) #el hijo...
		     {
		        close(CHILD);
			print "Fork realizado\n" if ($debugmode);
		        $dccsend=IO::Socket::INET->new(LocalPort=> $puerto,
			                              Type=>SOCK_STREAM,
						      Reuse=>1,
 		                                      Listen=>10);
                        unless($dccsend)
			  {
			    Gtk->_exit(1);
			  }
                        $dccsend->autoflush(1);
		        open (FILESEND,"$archivo");
			
          	        if ($client=$dccsend->accept())
	                 {
			   print "Enviando...\n" if ($debugmode);
			   print PARENT "Empezando a enviar\n";
			   my $respuesta="";
			   my $yaenviado=0;
			   my $bytes;
			   my $transfer=0;
			   my $actual;
			   my $horainicio=time();
			   while ($bytes=sysread(FILESEND,$datos,1024))
			     {
				$sent=send($client,$datos,1024);
				$yaenviado+=$sent;
				$actual=time();
		                $transfer=(int($yaenviado*100/($actual-$horainicio)/1024))/100 if ($actual-$horainicio);
				if (!$turbo)
				  {
				      sysread($client,$respuesta,1024);
				      if (unpack("N",$respuesta) != $yaenviado )
				        {
				          print "Error en $yaenviado\n" if ($debugmode);
				          last;	
            			        }
				      else
				        {
				print "Enviados: $yaenviado de $tamanno, a $transfer Kbytes/s\n" if ($debugmode);
				        }
				   }
				else
				  {
				    print "Enviado (Turbo): $yaenviado\n" if ($debugmode);
				  }
			     }
			     print "Envio finalizado. $yaenviado Bytes enviados en ",time()-$horainicio," segundos.\n" if ($debugmode);
			     print PARENT "Envio finalizado\n";
			     close FILESEND;
			     close $dccsend;
			     close PARENT;
			     Gtk->_exit(0);
		         }
	             }
		   else  # El padre...
		    {
			close(PARENT);
		        $piddccsend=$pid;
                        $dccsendhijo=Gtk::Gdk->input_add(fileno(CHILD),"read",\&dccsendinfo);
		    }
	             
		}
	       else 
	        {
		   $ventanas{general}->escribir("**No se pudo hacer el fork\n",$verde);
		}
             }
	      else
		  {
		    $ventanas{general}->escribir("**No se ha encontrado el archivo $archivo\n",$verde);
		    $statusbar->set_text("No se ha encontrado el archivo $archivo.");
		  }
           }
  }

sub dccsendinfo
   {
      my ($source,$condition,@data)=@_;
      if (my $datos=<CHILD>)
        {
      chomp $datos;
      $ventanas{general}->escribir("Recibido de dcc-send hijo: $datos\n");
        }
   }


package Ventana;

#Ventana principal
sub new {
my %vent=();
my $tipo=shift;
my $ref=\%vent;
bless $ref,$tipo;

$vent{canal}=shift;
my $a=( $vent{canal}=~m/#.+/);

$vent{entry}=new Gtk::Entry();
$vent{entry}->signal_connect("activate",\&enviadatos,$ref);
$vent{entry}->set_text("");
$vent{entry}->can_default($true);
$vent{entry}->grab_default();
$vent{entry}->signal_connect("key_press_event",\&teclapulsada,$ref);
#key_press_event
if ($main::config{nick}) {$vent{nick}=new Gtk::Label("$main::config{nick}  ")}
else {$vent{nick}=new Gtk::Label("NoNick")}
$vent{nickentry}=new Gtk::HBox($false,0);
$vent{nickentry}->pack_start($vent{nick},$false,$false,0);
$vent{nickentry}->pack_start($vent{entry},$true,$true,0);

$vent{topic}=new Gtk::Entry();
$vent{topic}->signal_connect("activate",\&cambiartopic,$ref);

$vent{topic}->set_text("No hay topic indicado.");

$vent{text}=new Gtk::Text(undef,undef);
$vent{text}->set_editable($false);
$vent{text}->set_word_wrap($true);

$vent{vscrollbar}=new Gtk::VScrollbar($vent{text}->vadj);

$vent{hbox}=new Gtk::HBox($false,0);
$vent{hbox}->pack_start($vent{text},$true,$true,0);
$vent{hbox}->pack_start($vent{vscrollbar},$false,$false,0);

if ($a)
{
$vent{listanicks}=new Gtk::List();
$vent{listanicks}->set_selection_mode('single');

$vent{nickscroll}=new Gtk::ScrolledWindow( undef,undef );
$vent{nickscroll}->set_usize(100,300);
$vent{nickscroll}->set_policy("automatic","always");
$vent{nickscroll}->add_with_viewport( $vent{listanicks});

my %listaitems=();

$vent{listaitems}=\%listaitems;

$vent{movible}=new Gtk::HPaned();
$vent{movible}->set_position(440);  #600
$vent{movible}->pack1($vent{hbox},$true,$true);
$vent{movible}->pack2($vent{nickscroll},$false,$false);
$vent{movible}->show_all();
}
#$vent{hbox}->pack_start($vent{nickscroll},$false,$false,4);

$vent{vbox}=new Gtk::VBox($false,2);
$vent{vbox}->border_width(10);
$vent{vbox}->pack_start($vent{topic},$false,$false,5);

if ($a)
  {
    $vent{vbox}->pack_start($vent{movible},$true,$true,5);
  }
else 
  {
    $vent{vbox}->pack_start($vent{hbox},$true,$true,5);
  }
$vent{vbox}->pack_start($vent{nickentry},$false,$false,5);


$vent{nickscroll}->show() if ($a);
$vent{vbox}->show_all();
$vent{etiqnotebook}=new Gtk::Label($vent{canal});
$main::notebook->append_page($vent{vbox},$vent{etiqnotebook});


$main::linescr{$canal}=[];

return $ref;

}

sub teclapulsada
   {
      ($widget,$this,$event)=@_;
    #  print "\$main::guin=$main::guin\n\$widget=$widget\n\$this=$this\n\$event=$event\n\$main::notebook=$main::notebook\n\n";
      my $tecla=$event->{keyval};
#      print "$tecla -> ",chr($tecla),"\n";
      if ($tecla==65289)     #Tab para nick_completion
       {
	   my $long=0;
           my $cadena=$widget->get_text();
	   $cadena =~/(\S+?$)/;
	   my $seminick=$1;
	   my $inicio=index($cadena,$seminick);
	   my $valtecla=chr($tecla);
	   $seminick.=$valtecla if ($tecla<260);
	   my $useminick=uc($seminick);
	   $long=length($useminick);
	   my @candidatos=();
           foreach $nick (@{$main::listadenicks{$this->{canal}}})
              {
	         $nick=~s/^[\@\+]//;
		 my $unick=uc($nick);
		 my $recortado = substr($unick,0,$long);
		 if ($recortado eq $useminick)
		    {
		     push @candidatos,$nick;
		    }
	      }
	   if (scalar(@candidatos)==1)
	     {
	       $cadena=~s/(\S+?$)/$candidatos[0]/e;
	       my $aintroducir="$cadena";
	       if ($inicio==0) { $aintroducir.=": "; }
	       $this->{entry}->set_text("$aintroducir");
	     }
	   elsif(scalar(@candidatos)>1)
	     {
	       my $num=0;
	       my $seguir=1;
	       my $vale=1;
	       while ($seguir)
	         {
	            my $letra=uc(substr($candidatos[0],$num,1));

                    SALFOR: foreach $nick (@candidatos)
	               {
		         my $unick=uc($nick);
		         unless (substr($unick,$num,1) eq $letra)
		          {
			    $vale=0;
			    last SALFOR;
		          }
		       }
		    if ($vale)
		      {
		      $num++;
		      }
		    else
		      {
		      $seguir=0;
		      }
		 }
	       my $aprox="";
	       foreach $nick (@candidatos)
	         {
		   if (length($nick)==$num)
		    {  $aprox=$nick; }
		 }
	       my $nickfinal=substr($aprox,0,$num);
	       $cadena=~s/(\S+?$)/$nickfinal/e;
	       my $aintroducir="$cadena";
	       $this->{entry}->set_text("$aintroducir");
	       $main::ventanas{$this->{canal}}->escribir("   @candidatos\n");
	     }	   
	   $main::timer=Gtk->timeout_add(0.05,\&focuse,$widget);
       }   
       elsif ($tecla==65362)
         {
#	   print "Antes: @{$main::linescr{$this->{canal}}}\n" if ($main::debugmode);
	   my $anterior=$widget->get_text();
	   my $lin="";
	   if ($lin=pop @{$main::linescr{$this->{canal}}})
	     {
	   unshift @{$main::linescr{$this->{canal}}},$lin;
	   #push @{$main::linescr{$this->{canal}}},$anterior if ($anterior);
	   $widget->set_text("$lin");
	     }
	   $main::timer=Gtk->timeout_add(0.05,\&focuse,$widget);
 #          print "Despues: @{$main::linescr{$this->{canal}}}\n" if ($main::debugmode);
	 }
       elsif ($tecla==65364)
         {
#	   print "Antes: @{$main::linescr{$this->{canal}}}\n" if ($main::debugmode);
	   my $anterior=$widget->get_text();
	   my $lin="";
	   if ($lin=shift @{$main::linescr{$this->{canal}}})
	     {
	   push @{$main::linescr{$this->{canal}}},$lin;
	   #push @{$main::linescr{$this->{canal}}},$anterior if ($anterior);
	   $widget->set_text("$lin");
	     }
	   $main::timer=Gtk->timeout_add(0.05,\&focuse,$widget);
           #print "Despues: @{$main::linescr{$this->{canal}}}\n" if ($main::debugmode);
	 }
   }

sub focuse
    {
      $main::guin->set_focus($widget);
      Gtk->timeout_remove($main::timer);
    }
   
sub escribir {
        my $this=shift;
	my $cadena=shift;
	my $color=shift;
	$this->{text}->insert(undef,$color,undef,$cadena) if ($this);
	}

sub escribirtopic {
        my $this=shift;
	my $cadena=shift;
	$this->{topic}->set_text($cadena);
	}

sub eliminar {
	my $widget=shift;
	my $this=shift;
	my $canal=$this->{canal};
        if ($canal ne 'general')
	  {
#	    &main::enviar("PART $canal\n");
	    my $numpag=$main::notebook->page_num($this->{vbox});
	    $this->{vbox}->destroy();
	    $main::notebook->remove_page($numpag);
	    delete($main::ventanas{$canal});
	  }
	else 
	  {
	  	&main::apagar(undef,"McK-IRC saliendo del cliente.\n");
	  }	
	}

sub eliminarnicks {
       my $this=shift;
       my @nicks = values %{$this->{listaitems}};
#       print "Eliminando nicks @nicks\n";
       $this->{listanicks}->remove_items(@nicks);
       }



sub mostrarnicks {
	my $this=shift;
	my $canal=$this->{canal};
	my @nicks;
	my @ops= grep { $_=~/^@.+/ } @{$main::listadenicks{$canal}};
	@ops=sort @ops;
	#print "ops: @ops\n";
	push @nicks,@ops if (@ops);
	my @voices= grep { $_=~/^\+.+/ } @{$main::listadenicks{$canal}};
	@voices=sort @voices;
	#print "voices: @voices\n";
	push @nicks,@voices if(@voices);
	my @normales=sort grep { $_=~/^[^\@\+].*/ } @{$main::listadenicks{$canal}};
	#print "Normales: @normales\n";
	push @nicks,@normales if (@normales);
#	print "nicks: @nicks\n";
	my $i;
	foreach $i (@nicks)
	   {
	    $this->{listaitems}->{$i} = new Gtk::ListItem( $i ); 
	    $this->{listaitems}->{$i}->show();
#	    print "***Nick: $i\t$this->{listaitems}->{$i}\n";
            $this->{listanicks}->append_items($this->{listaitems}->{$i});
	   }
#	my @lista=();
#	foreach $i (sort keys %{$this->{listaitems}})
#	   {
#	     push @lista,$this->{listaitems}->{$i};
#	   }
#	print "lista: @lista\n";
#        $this->{listanicks}->append_items(@lista);
	}

sub eliminaymuestranicks
   {
     my $this=shift;
     eliminarnicks($this);
     mostrarnicks($this);
   }

sub enviadatos
 {
	my $widget=shift;
  	my $this=shift;
	my $linea=$this->{entry}->get_text();
        $this->{entry}->set_text(""); 
	my @listamandatos;
        while ($linea=~s/^(.*)\n//)
           {
               push @listamandatos,$1;
           }
	push @listamandatos,$linea;
        if (scalar( @listamandatos) == 0)
           {
           	&main::procesar($this,$linea) if ($linea ne "");
	        push @{$main::linescr{$this->{canal}}},$linea;
           }
        else
           {
                foreach my $i (@listamandatos)
                      {
                          &main::procesar($this,$i);
                      }
           }
 }

sub cambiartopic
  {
	my $widget=shift;
	my $this=shift;
	my $topic=$this->{topic}->get_text();
	my $canal=$this->{canal};
	if ($canal ne "general")
	 {
  	     &main::enviar("TOPIC $canal :$topic\n");
	 }
  	
  }


package Dialogo;

sub new

{
my $class=shift;
my ($nick,$server)=@_;
%vent=();
my $ref=\%vent;
bless $ref,$class;

$vent{dialog}=new Gtk::Window("toplevel");
$vent{dialog}->set_title("Opciones");
$vent{dialog}->signal_connect("delete_event",\&findialogo,$ref);
$vent{dialog}->set_modal($true);
$vent{dialog}->set_policy($false,$false,$true);
$vent{dialog}->border_width( 15 );
$vent{dialog}->set_position("center");

$vent{lserver}=new Gtk::Label("Server:");
$vent{entryserver}=new Gtk::Entry();
$vent{entryserver}->set_text("$server");
$vent{entryserver}->signal_connect("activate",\&findialogo,$ref);
$vent{hboxserver}=new Gtk::HBox($true,2);
$vent{hboxserver}->pack_start($vent{lserver},$false,$false,0);
$vent{hboxserver}->pack_start($vent{entryserver},$true,$true,0);

$vent{lcanal}=new Gtk::Label("Contraseña OP:");
$vent{entrycanal}=new Gtk::Entry();
$vent{entrycanal}->set_visibility( $false );
$vent{entrycanal}->set_text("$main::config{clave}");
$vent{entrycanal}->signal_connect("activate",\&findialogo,$ref);
$vent{hboxcanal}=new Gtk::HBox($true,2);
$vent{hboxcanal}->pack_start($vent{lcanal},$true,$true,0);
$vent{hboxcanal}->pack_start($vent{entrycanal},$true,$true,0);
###
$vent{lnick}=new Gtk::Label("Nick:");
$vent{entrynick}=new Gtk::Entry();
$vent{entrynick}->set_text("$nick");
$vent{entrynick}->signal_connect("activate",\&findialogo,$ref);
$vent{hboxnick}=new Gtk::HBox($true,2);
$vent{hboxnick}->pack_start($vent{lnick},$false,$false,0);
$vent{hboxnick}->pack_start($vent{entrynick},$true,$true,0);

$vent{aceptar}=new Gtk::Button("Aceptar");
$vent{aceptar}->signal_connect("clicked",\&findialogo,$ref);

$vent{dvertbox}=new Gtk::VBox($true,5);
$vent{dvertbox}->pack_start($vent{hboxnick},$true,$true,0);
$vent{dvertbox}->pack_start($vent{hboxserver},$true,$true,0);
$vent{dvertbox}->pack_start($vent{hboxcanal},$true,$true,0);
$vent{dvertbox}->pack_start($vent{aceptar},$true,$true,0);

$vent{dialog}->add($vent{dvertbox});

$vent{dialog}->show_all();


return $ref;
}



sub findialogo
     {
	my $widget=shift;
	my $this=shift;
        my $nick=$this->{entrynick}->get_text();
	$main::nick=$nick;
	$main::ventanas{general}->{nick}->set_text("$nick  ");
	my $serverdat=$this->{entryserver}->get_text();
	my $clave=$this->{entrycanal}->get_text();
	$main::config{clave}=$clave if ($clave);
	$serverdat=~/([^:]+)(:(\d{1,5}))?/;
	$server=$1;
	$puerto= $3 ? $3 : 6667;
	#print "Server: $server Puerto: $puerto\n";
#	my $canal=$this->{entrycanal}->get_text();
	if (($nick ne "")and($server ne ""))
            {
	        $this->{dialog}->hide();
		$main::config{server}=$server;
		$main::config{nick}=$nick;
		&main::conectar($server,$puerto);
#		&main::registranick($nick,$nick);
#		&main::entrarcanal($canal);
		}
	else {$this->{text}->insert(undef,undef,undef,"--No rellenó los campos correctamente\n");}
     }
