include <BOSL2/std.scad>
include <BOSL2/screws.scad>
DB = 10;
DU = 14.4;
L = 12;
$fn = 50;
WALL = 2.4;
R = 2;
CUT = true;
SL = 5;

module my_screw_hole(Len=20)
{
   screw_hole("M5", l=Len, head="none", 
    anchor=TOP, 
    thread = true,
    tolerance="7G", 
    $slop=0.1, bevel2=true);
}

module cut_cyl()
{
    //difference()
    {
    //    cuboid([5,5,5], center = true);
        cyl(h=5, r1=0, r2=2.5, center = false);    
    }
}

module part()
{
diff()
cyl(l = L, d1 = DB, d2 = DU, rounding2=R)
{
attach(BOTTOM) my_screw_hole(SL);
tag("remove") translate([0, 0, 2*SL])attach(BOTTOM) cut_cyl();
};
    
}

module perform_cut()
{
    if (CUT)
        left_half() children();
    else children();
}

perform_cut()
part();



