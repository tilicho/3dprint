include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 50.0;//[0:0.1:100]
D2 = 45.0;//[0:0.1:100]
H = 65.0;//[0:0.1:200]
W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
Hhat = 10.0;//[0:0.1:100]
E = 0;////[0:0.1:100]

$fn = 50;
CUT = true;
HAT = false;
BODY = true;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module rotate_head()
{
    if (!BODY)
        rotate([180, 0, 0]) children();
    else
        children();
}

module obj()
{

if (BODY)
{
    difference()
    {

    cyl(d = D2, d2 = D1, h = H);

    translate([0,0,W])
    cyl(d = D2-2*W, d2 = D1-2*W, h = H);

    }
}

if (HAT)
{
    rotate_head()   
    translate([0,0,H/2-Wh*2])
    difference()
    {

    cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    cyl(d = D1 + E,  h = Hhat);

    }
}

}


perform_cut()
obj();
