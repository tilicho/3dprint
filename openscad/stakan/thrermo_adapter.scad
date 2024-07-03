include <BOSL2/std.scad>
include <BOSL2/screws.scad>
EE = 1;

D1 = 54.16 + EE;//[0:0.1:200]
DY1 = 18.53 + EE;//[0:0.1:200]


D2 = D1;//[0:0.1:200]
DY2 = DY1;//[0:0.1:200]

H = 26.14 + EE;//[0:0.1:200]

W = 1.2;//[0:0.1:200]
Wh = 1.2;//[0:0.1:200]
Hhat = 10.0;//[0:0.1:200]
E = 0.4;////[0:0.1:200]

R = 1;////[0:0.1:200]
$fn = 50;
CUT = false;
HAT = true;
BODY = true;

CUT_CIRCLE = false;

CIRCLE_D = 2.0 * (Hhat * 2.0 / 3.0);

FX = 32.11;
FY = 3.3;
FH = 18.3;

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

    prismoid([D1+2*W+E, DY1+2*W+E], [D2+2*W+E, DY2+2*W+E], rounding=R, h = H+E)
    {
    attach(FRONT)
    linear_extrude(0.2)
    translate([0,-5,0])
    text(text="visor", size=10, anchor=CENTER);
    
    attach(BACK)
    linear_extrude(0.2)
    translate([0,-5,0])
    text(text="termo", size=10, anchor=CENTER);
    
    }
    
    translate([0,0,W])
    prismoid([D1+E, DY1+E], 
             [D2+E, DY2+E], 
             rounding=R, h = H + E);
    
    //cyl(d = D2-2*W, d2 = D1-2*W, h = H);

    if (CUT_CIRCLE)
    {
        
        translate([0, 0, H])
        rotate([90, 0, 0])
        cyl(d = CIRCLE_D, h = DY2 + 2 * E, $fn=6);
    }
    
    }
    
    fy=FY-E;
    #translate([-(D1+E)/2+FX/2, -(DY1+E)/2+fy/2, W])
    cuboid([FX,fy,FH],anchor=BOTTOM,
        rounding=R,
        edges="Z");
        
}

if (HAT)
{
    dx = D1+2*W+E;
    dy = DY1+2*W+E;
    
    dx2 = D2+2*W+E;
    dy2 = DY2+2*W+E;
    
    perform_rotate()
    translate([0,0,H - Hhat+E*2])//+ Wh*2])
    difference()
    {

    prismoid([dx + 2*Wh + E, dy + E + 2*Wh],
            [dx2 + E + 2*Wh, dy2 + E + 2*Wh], 
            rounding=R, h = Hhat);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    prismoid(
        [dx+E, dy+E], 
        [dx2+E, dy2+E], 
        rounding=R, h = Hhat);
    //cyl(d = D1 + E,  h = Hhat);

    }
}

}


perform_cut()
obj();
