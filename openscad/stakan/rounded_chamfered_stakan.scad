include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <rounded_chamfered_cube.scad>

D1 = 65.0;//[0:0.1:100]
D2 = 65.0;//[0:0.1:100]
H = 24.0;//[0:0.1:100]

W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
Hhat = 10.0;//[0:0.1:100]
E = 0.1;////[0:0.1:100]
R = 20;
$fn = 50;
CUT = false;
HAT = true;
BODY = true;
CH_EXT = 3;

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

    facet_cube(D1,D2,rounding=R, h = H, chamfer1=CH_EXT);
    //prismoid(D1, D2, rounding=R, h = H);
    //cyl(d = D2, d2 = D1, h = H);

    translate([0,0,W])
    facet_cube(D1-2*W,D2-2*W,rounding=R, h = H+E, chamfer1=CH_EXT);
    
    //cyl(d = D2-2*W, d2 = D1-2*W, h = H);

    }
}

if (HAT)
{
    perform_rotate()
    translate([0,0,H+ Wh*2])
    difference()
    {
    facet_cube(D2 + E + 2*Wh, D2 + E + 2*Wh, rounding=R, 
        h = Hhat, chamfer2=CH_EXT);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    facet_cube(D2 + E, D2 + E, rounding=R, h = Hhat, chamfer2=CH_EXT);
    //cyl(d = D1 + E,  h = Hhat);

    }
}

}


perform_cut()
obj();
