#!/usr/bin/perl
#-----------------------------------------------------------------------------
#   Taller de Perl v 1.0   Francisco J. Palacios   <wrider@sourceforge.net>
#-----------------------------------------------------------------------------

print("Content-type: text/html\n\n");

print("<html><head><title>Taller de Perl - CGI-Perl : Variables de entorno</title></head>\n");
print("<body bgcolor=white>\n");
print("<center><h1>Variables de entorno de %ENV{ }</h1></center>\n");
print("<hr WIDTH='100%'>\n");
print("<ul>\n");
foreach $variable (keys %ENV) 
{
   print("<li><font color=red>$variable</font> = $ENV{$variable}\n");
}
print("</ul></body></html>\n");
