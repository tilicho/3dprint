include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 50.0;//[0:0.1:100]
D2 = 45.0;//[0:0.1:100]
H = 65.0;//[0:0.1:200]
W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
Hhat = 10.0;//[0:0.1:100]
E = 0.1;////[0:0.1:100]

$fn = 80;
CUT = true;
HAT = false;
BODY = true;
SEPERATOR = false;
SEPERATOR_UP = false;
SEP_W_UP = 1.8;
SEP_W_UP2 = 1.2;
D_SEP_UP = 4;//[0:0.1:200]
N_SEP = 4;
ChamferHat = 1;

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

module sep(sep_tolerance = 0.2)
{

        
        
        //tag("keep")
        //translate([0,0,-H/2+W+sep_tolerance])
        //cyl(d=6.11,h=H-SEP_W_UP, anchor=BOTTOM);
        
  //perform_cut()   
        tag("keep")
        zrot_copies(n=N_SEP)
        difference()
        {
            translate([0,0,-H/2+W+sep_tolerance])
            cuboid([D1/2,W,H-SEP_W_UP-W], anchor=LEFT+BOTTOM);
    
            difference()
            {
            cyl(d = D2+4*W, d2 = D1+4*W, h = H);
            cyl(d = D2-sep_tolerance-2*W, d2 = D1-sep_tolerance-2*W, h = H+0.1);
            }
        };
}

module obj()
{

if (BODY)
{
    diff()
    {

    cyl(d = D2, d2 = D1, h = H, chamfer1=ChamferHat);

    //if (SEPERATOR)
    //{
    //    tag("keep")
    //    cuboid([D1/2,W,H], anchor=LEFT);
    //}
    
    tag("remove")
    translate([0,0,W])
    cyl(d = D2-2*W, d2 = D1-2*W, h = H, chamfer1=ChamferHat);
    
    

    }
    
}

if (SEPERATOR)
{
    sep_tolerance = 0.2;
    
    difference()
    {
        union()
        {
        sep();
        translate([0,0,-H/2+W+sep_tolerance])
        cyl(d=6.11,h=H-SEP_W_UP-W, anchor=BOTTOM);
        };
        
        translate([0,0,
            -H/2+W+sep_tolerance+(H-W-SEP_W_UP-6) ])
        cyl(d=4.11,h=H-W-SEP_W_UP, anchor=BOTTOM);
        
    }
}

if (HAT)
{
    rotate_head()   
    translate([0,0,H/2-Wh*2])
    difference()
    {

    cyl(d = D1 + E + 2*Wh, h = Hhat, chamfer2=ChamferHat);

    translate([0,0,-Wh])
    cyl(d = D1 + E,  h = Hhat, chamfer2=ChamferHat);

    }
}

if (SEPERATOR_UP)
{
    sep_tolerance = 0.8;

    color("green")
    difference()
    {
       translate([0,0,H/2-W])
       cyl(d=D2+2*W, d2=D1+2*W, h=W, 
        anchor=BOTTOM);
       
        translate([0,0,H/2-SEP_W_UP2])
        cyl(d=D_SEP_UP,h=SEP_W_UP2, anchor=BOTTOM);
        
       difference()
       {
            cyl(d = D2+4*W, d2 = D1+4*W, h = H);
            cyl(d = D2-2*W-sep_tolerance, d2 = D1-2*W-sep_tolerance, h = H+0.1);
       };
       
       pie_slice(d = D2-2*W+sep_tolerance, d2 = D1-2*W+sep_tolerance, h = H, ang=360/N_SEP);
       
       
    }
}

}


perform_cut()
obj();
