include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 62;
D2 = 55.6;
H = 15;
W = 1.8;
Wh = 1.8;
Hhat = 5;
E = 0;//1.2;

$fn = 50;
CUT = true;
HAT = true;
BODY = true;

cyl_center_d = 6;
sq_width = 6.8;
sq_len  = 58.4;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module obj()
{

if (BODY)
{
    difference()
    {

        cyl(d = D2 + 2*W, d2 = D1 + 2*W, h = H);

        translate([0,0,W/2])
        cyl(d = D2, d2 = D1, h = H);

        translate([0,0,W/2])
        cuboid([sq_len, sq_width, H + E], rounding=1, edges="Z");
    }
    
    cyl(d = cyl_center_d, h = H);
}

if (HAT)
{
    translate([0,0,H/2-Wh*2 + Hhat])
    difference()
    {

    cyl(d = D1 + E + 4*Wh, h = Hhat);

    translate([0,0,-Wh])
    cyl(d = D1 + E + 2*Wh,  h = Hhat);

    }
}

}


perform_cut()
obj();
