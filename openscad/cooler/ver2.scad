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

FRAME = false;
FY = 74;
FW = 2.4;
FZ = 20;
RFRAME = 1.2;

MASK_W = 1.2;
MASK_H = 1.2;

PROTECTOR2 = true;


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

module prot_mask(d, w, kn=6)
{
    n = d / (kn * MASK_W);
    
    difference()
    {
        {
            zrot(60)
            zrot_copies([0, 60])
            xcopies(MASK_W*kn, n=n)
            cuboid([MASK_W, d, MASK_H]);
        };
    
        difference()
        {
            zcyl(d = 2*d, h = MASK_H+E);
            zcyl(d = d+2*w, h = MASK_H+E);
        };
        
    }
    
    difference()
    {
        zcyl(d = d+w*2, h = MASK_H);
        zcyl(d = d, h = MASK_H+E);
    };

}

module protector()
{
    difference()
    {
        translate([0, L2/2-PDY, -H/2])
        {
            difference()
            {
                zcyl(d = PD+2*PW, h = PH, anchor=BOTTOM);
                translate([0,0,-E/2])
                zcyl(d = PD, h = PH+E, anchor=BOTTOM);
                
            };
            
        }
            
       cuboid([L+2*W, W+PDH, H+PDH], 
                rounding=R, edges="Z");
                
       xflip_copy()
        translate([-L/2-W, L2/2-W/2, H/2])
            xcyl(l=PH, d = D2, $fn = 10);
            
       translate([0, -PW*2, 0])
       cuboid([PCUTW, PD+PW*2, H2], 
                rounding=R, edges="Z");
    }
    
    translate([0, L2/2-PDY, PH-H/2+PW/2])
    prot_mask(PD, PW);
}

module protector2()
{
    translate([0, L2/2-PDY, -H/2-PW/2])
    prot_mask(PD, PW);
    
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
            
if (PROTECTOR2)
    rotate_protector()
        color("green")
            protector2();
            

if (FRAME)
    color("green")
        frame();