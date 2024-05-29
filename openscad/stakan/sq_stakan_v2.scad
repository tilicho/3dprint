include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 45.0;//[0:0.1:100]
DY1 = 15.0;//[0:0.1:100]


D2 = 50.0;//[0:0.1:100]
DY2 = 15.0;//[0:0.1:100]

H = 65.0;//[0:0.1:100]

W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
Hhat = 10.0;//[0:0.1:100]
E = 0.1;////[0:0.1:100]
R = 5;////[0:0.1:100]
$fn = 50;
CUT = false;
HAT = true;
BODY = true;

CUT_CIRCLE = true;

CIRCLE_D = 2.0 * (Hhat * 2.0 / 3.0);

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

    prismoid([D1, DY1], [D2, DY2], rounding=R, h = H);
    //cyl(d = D2, d2 = D1, h = H);

    translate([0,0,W])
    prismoid([D1-2*W, DY1 - 2*W], 
             [D2 - 2*W, DY2 - 2*W], 
             rounding=R, h = H + E);
    
    //cyl(d = D2-2*W, d2 = D1-2*W, h = H);

    if (CUT_CIRCLE)
    {
        
        translate([0, 0, H])
        rotate([90, 0, 0])
        cyl(d = CIRCLE_D, h = DY2 + 2 * E, $fn=6);
    }
    
    }
}

if (HAT)
{
    perform_rotate()
    translate([0,0,H - Hhat])//+ Wh*2])
    difference()
    {

    prismoid([D2 + E + 2*Wh, DY2 + E + 2*Wh],
            [D2 + E + 2*Wh, DY2 + E + 2*Wh], 
            rounding=R, h = Hhat);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    prismoid(
        [D2 + E, DY2 +E], 
        [D2 + E, DY2 +E], 
        rounding=R, h = Hhat);
    //cyl(d = D1 + E,  h = Hhat);

    }
}

}


perform_cut()
obj();
