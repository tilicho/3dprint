include <BOSL2/std.scad>

D = 23;
W = 3.5;
H = 5;
$fn = 50;
E = 0.1;

difference()
{
linear_extrude(H, center=true)
circle(d = D);

linear_extrude(H+E, center=true)
circle(d = D-2*W);

}