include <BOSL2/std.scad>
include <BOSL2/screws.scad>

BINDING = true;
L = 85;
H = 5;
W = 1.8;
R=0.6;
RF = 2;

L2 = 15;
H2 = 10;
E = 0.1;

D1 = 3;
D2 = 6.6;
DH = 15;
$fn = 50;

PROTECTOR = true;
PDY = 7;
PH = 22;
PD = 85;
PW = 1.2;
PDH = 0.8;
PCUTW = 20;

FRAME = true;
FY = 64;
FW = 2.4;
FZ = 20;
RFRAME = 1.2;




module binding()
{
    difference()
    {
    cuboid([L+2*W, W, H], 
       rounding=R, edges="Z");

    xflip_copy()
    translate([DH/2, 0, 0])
    ycyl(l = W+E, d = D1, $fn = 8);

    }   
       
    xflip_copy()
    translate([-L/2-W, L2/2-W/2, H/2])
    {
    difference()
    {
        cuboid([W, L2, H2],
            rounding=R, edges="Z");

        xcyl(l=W+E, d = D2, $fn = 10);
    }

    }    


    xflip_copy()
    translate([-L/2-W/2,W/2,0])
    fillet(l = H, r = RF, spin=0);
}

module rotate_protector()
{
    if (PROTECTOR && !BINDING && !FRAME)
        rotate([180,0,0]) children();
    else
        children();
}

module protector()
{
    difference()
    {
        translate([0, L2/2-PDY, -H/2])
            difference()
            {
                zcyl(d = PD+2*PW, h = PH, anchor=BOTTOM);
                translate([0,0,-E/2])
                zcyl(d = PD, h = PH+E, anchor=BOTTOM);
                
            };
            
       cuboid([L+2*W, W+PDH, H+PDH], 
                rounding=R, edges="Z");
                
       xflip_copy()
        translate([-L/2-W, L2/2-W/2, H/2])
            xcyl(l=PH, d = D2, $fn = 10);
            
       cuboid([PCUTW, PD, H2], 
                rounding=R, edges="Z");
    }
}

module frame()
{
    dz = (FZ-H2)/2;
    xflip_copy()
    translate([-L/2-W-FW, L2/2-W/2, H/2])
    {
        difference()
        {
            translate([0, -FY/2+L2/2, dz])
            cuboid([FW, FY, FZ],
                rounding=RFRAME, edges="Z");

            xcyl(l=FW+E, d = D2, $fn = 10);
        }
    
        
     }
     
     translate([0, L2/2-W/2, H/2+dz])
     translate([0,-FY+L2/2+FW/2,0])
     {
        difference()
        {
            cuboid([L+2*FW+2*W+RFRAME*2, FW, FZ], 
               rounding=RFRAME, edges="Z");

            xflip_copy()
            translate([DH, 0, 0])
                ycyl(l = FW+E, d = D2, $fn = 8);

            ycyl(l = FW+E, d = D2, $fn = 8);
        }
        
        xflip_copy()
        translate([L/2+W+FW/2, FW/2,0])
        fillet(l = FZ, r = RFRAME, orient=BOTTOM);   
     }
}

if (BINDING)
binding();

if (PROTECTOR)
    rotate_protector()
        color("red")
            protector();

if (FRAME)
    color("green")
        frame();