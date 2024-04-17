include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 50;
D2 = 45;
H = 65;
W = 2.4;
Wh = 1.8;
Hhat = 10;
E = 0;//1.2;

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
