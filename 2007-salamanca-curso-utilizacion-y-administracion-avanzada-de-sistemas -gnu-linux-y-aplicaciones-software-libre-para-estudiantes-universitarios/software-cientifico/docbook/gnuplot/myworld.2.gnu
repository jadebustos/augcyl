# set terminal png transparent nocrop enhanced font arial 8 size 420,320 
# set output 'world.2.png'
set dummy u,v
set angles degrees
set parametric
set view 70, 40, 0.8, 1.2
set samples 32, 32
set isosamples 9, 9
set mapping spherical
set yzeroaxis linetype 0 linewidth 1.000
set ticslevel 0
set title "3D version using spherical coordinate system" 
set urange [ -90.0000 : 90.0000 ] noreverse nowriteback
set vrange [ 0.00000 : 360.000 ] noreverse nowriteback
splot cos(u)*cos(v),cos(u)*sin(v),sin(u) with lines lt 5 ,'world.dat' with lines lt 3 
