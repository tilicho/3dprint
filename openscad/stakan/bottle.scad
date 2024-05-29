include <BOSL2/std.scad>
include <BOSL2/screws.scad>
include <BOSL2/bottlecaps.scad>

D1 = 50.0;//[0:0.1:100]
D2 = 50.0;//[0:0.1:100]
H = 55;//[0:0.1:200]
W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
HhatD = 10;//[0:0.1:100]
E = 0.1;////[0:0.1:100]

NECK_DD = 30.0; ////[0:0.1:100]
NECK_ALFA = 45.0;////[0:0.1:100]

$fn = 50;
CUT = true;
HAT = false;
BODY = true;
PCO = true;


NECK_D = PCO ? 23.5 : NECK_DD;
Hhat = PCO ? 17 : HhatD;

THREAD_D = 2;////[0:0.1:100]
CYL_H = tan(NECK_ALFA) * (D1 - NECK_D) / 2.0;


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
    
    translate([0,0,H/2])
    {
        translate([0,0,CYL_H/2])
        {
            difference()
            {
                cyl(d = D1, d2 = NECK_D, h = CYL_H);
                cyl(d = D1-2*W, d2 = NECK_D-2*W, h = CYL_H+E);
            }
            
            translate([0,0,CYL_H/2+Hhat/2])
            if (PCO)
            {
                color("red")
                translate([0,0,Wh/2])
                {
                    difference()
                    {
                        pco1881_neck(wall = Wh, anchor = "tamper-ring");
                        translate([0,0,-8])
                        cyl(d = NECK_D + 20, h = 10);
                    }
                } 
            }
            else
            {
                generic_bottle_neck(
                        support_d = 0, 
                        neck_d = NECK_D,
                        id = NECK_D-2* Wh,
                        thread_od = NECK_D+THREAD_D,
                        height = Hhat,
                        wall = Wh,
                        anchor=CENTER
                    );
            }
        }
    }       
}

if (HAT)
{
        rotate_head()                
        translate([0,0,H/2 + Hhat + CYL_H])
        {
            if (PCO)
            {
                pco1881_cap(orient=DOWN, wall = Wh);
            }
            else
                generic_bottle_cap(
                thread_depth=THREAD_D,
                neck_od = NECK_D, 
                height = Hhat, 
                wall = Wh, 
                orient=DOWN,
                anchor=UP, 
                texture="ribbed");
        }
}

}


perform_cut()
obj();
