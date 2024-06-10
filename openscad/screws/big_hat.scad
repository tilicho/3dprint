include <BOSL2/std.scad>
include <BOSL2/screws.scad>
E = 0.1;
HEAD_SIZE = 10;
HEAD_H = 10;
THREAD_LEN = 10;
THREAD = "M8,10";
HEAD_TYPE="hex";//["hex", "socket", "cheese", "pan"]

SCREW = true;
NUT = false;
HOLE = true;

NUT_THREAD = "M8";
NUT_THICK = 4;

HOLE_H = 6;
HOLE_W = 16;

SLOP = 0.1;

CUT = false;
$fn=50;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

spec = screw_info(THREAD,head=HEAD_TYPE);
newspec = struct_set(spec,["head_size",HEAD_SIZE,"head_height",HEAD_H]);

perform_cut()
{

if (SCREW)
color("red")
rotate([180, 0, 0]) 
    translate([0,0,1.7])
    screw(newspec, tolerance="6g", 
        thread_len=THREAD_LEN, atype="shaft");
    
if (NUT)
translate([HEAD_SIZE*2, 0, 0])    
nut(NUT_THREAD, thickness=NUT_THICK, tolerance="7G", $slop=SLOP);


if (HOLE)
{
//translate([HEAD_SIZE*4, 0, 0])    
{
difference()
{
cuboid ([HOLE_W, HOLE_W, HOLE_H],
    rounding = 3, edges="Z");
screw_hole(NUT_THREAD, l=HOLE_H+E, head="none", thread=true,  tolerance="8G", $slop=SLOP);
}
//nut(NUT_THREAD, thickness=NUT_THICK, tolerance="7G");

}
}
}