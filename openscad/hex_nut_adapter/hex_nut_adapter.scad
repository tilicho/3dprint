include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D = 13;
H = 16;
DH = 5.4;
E = 0.01;
WALL = 1.2;
INNER_HEX = "M5"; //["M3", "M4", "M5", "M6"]

$fn = 100;
CUT = false;


module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

perform_cut()
difference()
{
cyl(d=D, h=H, 
    texture="trunc_ribs", 
    tex_taper=5,
    tex_size=[4.5,1]);
cyl(d=DH, h = H+E);


translate([0,0,-H/2 + WALL])
nut_trap_inline(H, INNER_HEX, $slop=0.2);
}