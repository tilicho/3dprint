include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 30.0;//[0:0.1:100]
DY1 = 14.5;//[0:0.1:100]


D2 = 47;//[0:0.1:100]
DY2 = 31;//[0:0.1:100]

H = 75.0;//[0:0.1:100]

W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
Hhat = 15.0;//[0:0.1:100]
E = 0.1;////[0:0.1:100]
R = 3;////[0:0.1:100]
$fn = 50;
CUT = false;
HAT = false;
BODY = true;

OVERHAT = true;
OVERHAT_H = 10;

CUT_CIRCLE = true;

CIRCLE_D = 2.0 * (Hhat * 2.0 / 3.0);

TEST = false;
SHIFTED = true;

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

module shifted_prismoid(dx, dy, dx2, dy2, h = 0)
{
prismoid([dx, dy], [dx2, dy2], 
    shift=[SHIFTED ? (dx-dx2)/2 : 0, 0], rounding=R, h = h);
}

module obj()
{

if (BODY)
{
    diff()
    {

        shifted_prismoid(D1+2*W, DY1+2*W, D2+2*W, DY2+2*W, h = H);
        //cyl(d = D2, d2 = D1, h = H);

        tag("remove")
        translate([0,0,W])
        shifted_prismoid(D1, DY1, 
                 D2, DY2, 
                 h = H + E);
        
        //cyl(d = D2-2*W, d2 = D1-2*W, h = H);
        
        if (OVERHAT)
        {
            translate([SHIFTED ? (D1-D2)/2: 0, 0, H])
            {
                difference()
                {
                    shifted_prismoid(D2+2*W, DY2+2*W, D2+2*W, DY2+2*W, h = OVERHAT_H);
                    
                    shifted_prismoid(D2, DY2, D2, DY2, h = OVERHAT_H + E);
                }
            
                
            }
        }

        if (CUT_CIRCLE)
        {
            tag("remove")
            translate([0, 0, H + OVERHAT_H])
            rotate([90, 0, 90])
            cyl(d = CIRCLE_D, h = D2 + 2 * E, $fn=6);
        }
    
    }
    
    
}

if (HAT)
{
    perform_rotate()
    translate([SHIFTED ? (D1-D2)/2: 0,0,H + Hhat])//+ Wh*2])
    difference()
    {

    shifted_prismoid(D2 + E + 4*Wh, DY2 + E + 4*Wh,
            D2 + E + 4*Wh, DY2 + E + 4*Wh, 
            h = Hhat);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    shifted_prismoid(
        D2 + E +2*W, DY2 +E+2*W, 
        D2 + E+2*W, DY2 +E+2*W, 
        h = Hhat);
    //cyl(d = D1 + E,  h = Hhat);

    }
}

}


perform_cut()
obj();
