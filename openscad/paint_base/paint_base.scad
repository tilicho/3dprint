include <BOSL2/std.scad>

DB = 40;
DU = 2.4;
L = 30;
$fn = 50;
WALL = 2.4;
R = 1;
REMOVE = false;

if (REMOVE)
{

    diff()
    cyl(l = L, d1 = DB, d2 = DU)
    tag("remove") translate([0,0,-WALL])
    cyl(l = L, d1 = DB, d2 = DU, rounding2=R);
}
else
{
    cyl(l = L, d1 = DB, d2 = DU);
}

