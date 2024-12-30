include <BOSL2/std.scad>

D = 120;
H = 7;
$fn = 80;
E = 0.1;

DI = 25;
HI = 3;

difference()
{
zcyl(d = D, h = H, anchor=TOP);
translate([0,0,E])
zcyl(d = DI, h = HI, anchor=TOP);
}