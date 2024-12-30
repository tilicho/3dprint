include <BOSL2/std.scad>

D = 24.1;
W = 1.2;
WD = 0.8;
H = 5.0;
$fn = 50;
E = 0.1;

CHA = 1;

/*
difference()
{
linear_extrude(H+W, center=false)
circle(d = D+2*W);

translate([0,0,W])
linear_extrude(H+E, center=false)
circle(d = D);

}*/

difference()
{
zcyl(d= D+2*W, h=H+WD, chamfer1=CHA);

translate([0,0,WD])
zcyl(d= D, h=H+E, chamfer1=0);
}