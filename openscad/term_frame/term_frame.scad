include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

DX = 44.6;
DY = 25;
DZ = 3.4;
WALL = 4.2;
R = 2;
RI = 0.5;
E = 1.01;
$fn = 50;
DRAW_BOX = false;

RING_R = 8.4;
RING_WALL = 3.5;
ES = 0.4;

difference()
{                
cuboid([DX + 2*WALL, DY + 2*WALL, DZ], 
                //p1 = [0,0,0], 
                rounding = R,
                edges = "Z"
                );

cuboid([DX + RI*2 + ES, DY + RI*2 + ES, DZ+E], 
                //p1 = [0,0,0], 
                rounding = RI,
                edges = "Z"
                );                


                
}

if (DRAW_BOX)
color("blue") 
cuboid([DX, DY, DZ+E], 
                );         

translate([0, -DY/2 - WALL, -DZ/2])
linear_extrude(DZ)
ring(r1 = RING_R, r2 = RING_R - RING_WALL, n = 32, 
        angle = [180,360]);  
