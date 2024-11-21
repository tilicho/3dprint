include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <rounded_chamfered_cube.scad>

D1 = 60.0;//[0:0.1:250]
DY1 = 21.0;//[0:0.1:250]

H = 45.0;//[0:0.1:200]

W =    1;//[0:0.1:200]

Hhat = 20.0;//[0:0.1:200]

E = 0.4;////[0:0.1:200]
//R = 5;////[0:0.1:200]

R1 = 8;

CUT = false;
HAT = true;
BODY = false;

CH_EXT = 2;
$fn=100;

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

module obj()
{

if (BODY)
{
    difference()
    {

    cuboid([D1+2*W+E, DY1+2*W+E, H+E],
             rounding=R1, edges="Z", 
             except=TOP);
   
    translate([0,0,W])
    cuboid([D1+E, DY1+E, H+E],
             rounding=R1, edges="Z", except=TOP);
    }
}

if (HAT)
{
    perform_rotate()
    translate([0,0,H/2])//+ Wh*2])
    difference()
    {
    
    facet_cube(
        D1 + E + 4*W, 
        DY1 + E + 4*W,
        rounding=R1, 
        h = Hhat+E, 
        chamfer2=2, 
        e = 0.1);
        
    
    
    //cuboid([D1 + E + 4*W, DY1 + E + 4*W, Hhat+E],
     //       rounding=R1,except=BOTTOM, edges="Z");
   /*
    translate([0,0,-W])
    facet_cube(D1+2*W+E, DY1+2*W+E,
        rounding=R1, 
        h = Hhat+E, chamfer2=2);
     */ 

    sx = (D1+2*W+E) / (D1 + E + 4*W);
    sy = (DY1+2*W+E) / (DY1 + E + 4*W);
    sz = 1;
   
    translate([0,0,-W])
    scale([sx,sy,sz])
    facet_cube(
        D1 + E + 4*W, 
        DY1 + E + 4*W,
        rounding=R1, 
        h = Hhat+E, 
        chamfer2=2, 
        e = 0.1);    
  
  
    //cuboid(
    //    [D1+2*W+E, DY1+2*W+E, Hhat+E],
    //    rounding=R1,except=BOTTOM, edges="Z");

    }
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