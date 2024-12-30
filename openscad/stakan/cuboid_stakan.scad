include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <rounded_chamfered_cube.scad>

D1 = 60.6 + 0.4;//[0:0.1:250]
DY1 = 21.8 + 0.4;//[0:0.1:250]

H = 45.0+2;//[0:0.1:200]

W =    1.2;//1.0 //[0:0.1:200]

Hhat = 20.0;//[0:0.1:200]

E = 0.2;////[0:0.1:200]
//R = 5;////[0:0.1:200]

R1 = 8;

CUT = false;
HAT = false;
BODY = true;

CH_EXT = 2;
$fn=100;

LOCK_OFFSET = 0.8;
LOCK_H = 3;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module perform_rotate()
{
    if (HAT && !BODY)
        rotate([180,0,0]) children();
        
    else children();
}

module hat(e = E)
{
    hh = Hhat;
    lock_h = LOCK_H - e;
    difference()
    {
    
    cuboid([D1 + 4*W, DY1 + 4*W, hh],
            rounding=R1,except=BOTTOM, edges="Z");
   
    translate([0,0,-W])
    {
    cuboid(
        [D1+2*W+e-LOCK_OFFSET, DY1+2*W+e-LOCK_OFFSET, hh],
        rounding=R1,except=BOTTOM, edges="Z");
    
    
    translate([0,0,LOCK_H/2])
    cuboid(
        [D1+2*W+e, DY1+2*W+e, hh-lock_h],
        rounding=R1,except=BOTTOM, edges="Z");
    
    }
    }
}

module obj()
{

if (BODY)
{
    difference()
    {

    cuboid([D1+4*W, DY1+4*W, H],
             rounding=R1, edges="Z", 
             except=TOP);
   
    translate([0,0,W])
    cuboid([D1, DY1, H],
             rounding=R1, edges="Z", except=TOP);
    
    translate([0,0,H/2-Hhat/2+2*E])
    hat(e = 0);
    }
}

if (HAT)
{
    perform_rotate()
    translate([0,0,H/2-Hhat/2+2*E])//+ Wh*2])
    hat();
}




}


perform_cut()
obj();
/*
facet_cube(
        60, 
        21,
        rounding=8, 
        h = 20, 
        chamfer2=2, 
        e = 0.1);
        
*/