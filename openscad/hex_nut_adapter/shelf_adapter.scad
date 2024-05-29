include <BOSL2/std.scad>
include <BOSL2/screws.scad>


H = 15;
CH = 4.5;

S = 10.6;
CUT = false;
E = 0.1;
D = 19;

H_BOTTOM = 10;
DB1 = 10.5;
HB1 = 4.2;
DB2 = 6.6;

BASE = false;
HAT = true;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

//rotate([180,0,0])

perform_cut()

if (BASE)
diff()
{

cyl(d = D, h = H)
{
attach(BOTTOM)
tag("remove")
translate([0,0,-CH])
nut_trap_inline(CH, "M6", $slop=0.2);

attach(TOP)
tag("remove")
cuboid([S,S,H - CH], anchor=TOP);
}

}

if (HAT)
translate([0,0,H*1.5])
rotate([180,0,0])
{
    difference()
    {
        cyl(d = D, h = H_BOTTOM, $fn=6);
        translate([0,0,-H_BOTTOM/2])
        cyl(d = DB1, h = HB1, anchor=BOTTOM);
        cyl(d = DB2, h = H_BOTTOM+E);
        
    };
}

