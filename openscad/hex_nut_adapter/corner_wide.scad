include <BOSL2/std.scad>

H = 20;
H2 = 7.4;

DH = H - H2;
DY = 10;

L = 60;

WALL = 1.2;
WALL_Y = 15;

D = 4.7;
DO = 8;
HOLE_DX = 15;
HOLE_WALL = 3;

E = 0.01;
R = 4;

$fn = 50;

ONE_HOLE = true;

module shift_holes()
{
    if (ONE_HOLE)
        children();
    else
    {
xflip_copy()
translate([L/2-HOLE_DX,0,0])
        children();
    }
}

difference()
{

cuboid([L, DY, DH], rounding=R, edges = "Z", except=BOTTOM)
align(BOTTOM)
translate([0,-WALL_Y/2,0])
cuboid([L, DY+WALL_Y, WALL], rounding=R, edges = "Z",);

d0 = DO / cos(180/6);



translate([0,HOLE_WALL/2,0])
shift_holes()
rotate([0,30,0])
ycyl(d = d0, h = DY-HOLE_WALL+E, $fn=6);

di = D / cos(180/6);

shift_holes()
rotate([0,30,0])
ycyl(d = di, h = DY+E, $fn=6);


}


