include <BOSL2/std.scad>
include <BOSL2/screws.scad>

$fn=40;
THREADEED=true;
TEST=true;
TEST_SCREW=true;
CUT=true;
TEMPLATE=false;

module my_screw_hole(Len=20)
{
    if (THREADEED)
   screw_hole("M5", l=Len, head="none", thread=THREADEED, anchor=TOP, tolerance="7G", $slop=0.1, bevel2=true);
    else
    screw_hole("M3", l=Len, head="none", anchor=TOP, $slop=0.1, bevel2=true);
}

module cut_cyl()
{
    //difference()
    {
    //    cuboid([5,5,5], center = true);
        cyl(h=5, r1=0, r2=2.5, center = false);    
    }
}

module test()
{
left_half()
difference()
{
cuboid([1,1,2]);
cyl();
}
}

module part()
{
diff()
cuboid([80, 40, 19], rounding=3, edges="X")
{

tag("remove") translate([25, 10, 0]) attach(LEFT) cut_cyl();

translate([0, 10, 0]) attach(LEFT) my_screw_hole();

    
tag("remove") translate([25, -10, 0]) attach(LEFT) cut_cyl();
translate([0, -10, 0]) attach(LEFT) my_screw_hole();
    
    
translate([0, 10, 0]) attach(RIGHT) my_screw_hole();
translate([0, -10, 0]) attach(RIGHT) my_screw_hole();
};
    
}

module perform_cut()
{
    if (CUT)
        left_half() children();
    else if (TEMPLATE)
        top_half(z=38) children();
    else children();
}

module test_part()
{
    diff()
cuboid([20, 15, 15], rounding=3, edges="X")
{
    tag("remove") translate([10, 0, 0]) attach(LEFT) cut_cyl();

    attach(LEFT) my_screw_hole(5);
    
    attach(RIGHT) my_screw_hole(5);
    
    if (TEST_SCREW)
      tag("keep") attach(LEFT) translate([0, 0, 0.4]) screw("M5,5", head="none", anchor=TOP, tolerance="6g");
};

 

}


if (TEST)
{
   perform_cut() rotate([0, -90, 0]) test_part();
}
else
{
    perform_cut() rotate([0, -90, 0]) part();
}