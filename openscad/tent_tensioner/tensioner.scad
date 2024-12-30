include <BOSL2/std.scad>

DX = 35.0;
DY = 10.0;
DZ = 3.0;
D = 4;

R = 5;

N = 4;

$fn = 50;


diff()
{
cuboid([DX,DY,DZ], rounding=R, edges="Z");

tag("remove")
xcopies(n = 4, DX/N)
zcyl(h=10, d=D);

};