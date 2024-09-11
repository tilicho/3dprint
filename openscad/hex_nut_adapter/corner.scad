include <BOSL2/std.scad>

W = 20;
L = 50;
E = 0.1;
$fn=50;


SCREW_HAT_D = 11;
SCREW_D = 6;
HAT_L = 20;
SCREW_L = 17;
SCREW_OUT = 15;
CUT = false;


CORNER_HOLE_D = 12;
NUT_D = 9.4;

CORNER = false;

NUT_HOLDER = true;
CORNER_HOLE = false;
CORNER_PATTERN = true;

SCREW_INNER_L = SCREW_L - SCREW_OUT;

module perform_cut(cut=false)
{
    if (cut)
        front_half(s=200) children();
    else children();
}

module scr(anchor=TOP)
{

ch = (SCREW_HAT_D - SCREW_D)/2;

zcyl(d = SCREW_D, l = SCREW_INNER_L, anchor=anchor)
align(TOP)
zcyl(d = SCREW_HAT_D, l = HAT_L, chamfer1=ch);
}


module corner()
{

difference()
{
cuboid([L,W,L], rounding=0, edges="Y");

rotate([0,-45,0])
cuboid([L*2,W+E,L*2], rounding=0, edges="Z", anchor=BOTTOM);


zt = L / 2 - SCREW_INNER_L;


yrot_copies([0, -90])
translate([0,0,-zt])
scr();



}

}
WWALL = 2;

module nut_holder()
{
nut_h = 3.9;
wall = 1.2;
wall_inner = 2;

translate([0,WWALL/2,-wall_inner])
difference()
{
cuboid([7.9 + wall*2, W-WWALL, nut_h+wall], rounding=1, edges = "Z", except=BACK);
translate([0,0,wall/2+E])
rotate([0,0,360/12])
zcyl(d = NUT_D, l = nut_h, $fn=6);
}

translate([0,W/2,-wall_inner])
cuboid([7.9 + wall*2, W-WWALL, nut_h+wall], anchor=FRONT,
rounding=1, edges = "Z", except=FRONT);
}

module corner_hole()
{
wall_inner = 2;
difference()
{
cuboid([W,W,W]);
translate([0,WWALL,(W-CORNER_HOLE_D)/2-wall_inner])
ycyl(d = CORNER_HOLE_D, l = W+E);
}
}

module corner_pattern()
{
wall = 1.2;
wall_inner=2;
difference()
{
difference()
{
translate([0,wall/2,wall/2])
cuboid([L,W+wall,W+wall]);
cuboid([L,W,W]);
}

translate([0,WWALL,(W-CORNER_HOLE_D)/2-wall_inner])
ycyl(d = CORNER_HOLE_D, l = W+E);
}
}


module corner_pattern2()
{
wall = 1.2;
//wall_inner=2;
difference()
{
difference()
{
translate([0,wall/2,wall/2])
cuboid([L,W+wall,W+wall]);
cuboid([L,W,W]);
}

#translate([0,0,0])//(W-CORNER_HOLE_D)/2-wall_inner])
ycyl(d = SCREW_D, l = wall + W+E, anchor=FRONT);
}
}


{
if (CORNER)
perform_cut(CUT)
rotate([0, -45-90, 0])
corner();

translate([50, 0, 0])
perform_cut(CUT)
{
if (NUT_HOLDER)
translate([0,0,(W-CORNER_HOLE_D)/2])
nut_holder();

if (CORNER_HOLE)
corner_hole();

if (CORNER_PATTERN)
corner_pattern2();
}
}