include <BOSL2/std.scad>
include <BOSL2/screws.scad>

DIN = 8.6;
DOUT = 11.2;
L1 = 20;
L2 = 10;
DEND = 5;
WALL = 1.2;
E = 0.1;

$fn = 100;
CUT = false;

module adapter()
{

difference()
{
cyl(d = DOUT + 2*WALL, h = L1);

translate([0, 0, WALL])
cyl(d = DOUT, h = L1);

translate([0,0,-E])
cyl(d = DIN, h = L1);

}


}


module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

perform_cut()
adapter();