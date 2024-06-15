include <BOSL2/std.scad>
include <BOSL2/screws.scad>
SD = 2.5;//1.5 + 1.0;
WOrig = -0.2+SD;//1.5;
D1 = 118.8 - WOrig;//[0:0.1:100]
D2 = D1;//[0:0.1:100]
D3 = 123-SD;// - WOrig;
H = 38;//41.9;//[0:0.1:200]
H2 = 1.6;

DX = 2.4;
WS = 15;

H3 = 8 + DX;
W = 1.2;//[0:0.1:100]
W0 = 2.4;

//Wh = 1.2;//[0:0.1:100]
//Hhat = 10.0;//[0:0.1:100]
E = 0.1;////[0:0.1:100]

$fn = 50;
CUT = false;
HAT = false;
BODY = true;

R = 2;

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

module selector()
{
    zrot_copies(n=3)
    translate([D3/2,0,0])
    cube([D3/2,WS,DX], anchor=BOTTOM);
}

module obj()
{

if (BODY)
{
    difference()
    {

    cyl(d = D2+2*W0, d2 = D1+2*W0, h = H, chamfer1=R, anchor=BOTTOM);

    translate([0,0,W0])
    cyl(d = D2, d2 = D1, h = H, chamfer1=R, anchor=BOTTOM);
    
    }
    
    
    translate([0,0,H])
    difference()
    {
    cyl(d1 = D2+2*W0, d2 = D3+2*W, h = H2, anchor=BOTTOM);
    
    cyl(d = D2, d2 = D3, h = H2+E, anchor=BOTTOM);
    
    }
    
    translate([0,0,H+H2])
    difference()
    {
    cyl(d = D3+2*W, d2 = D3+2*W, h = H3, anchor=BOTTOM);
    
    cyl(d = D3, d2 = D3, h = H3+E, anchor=BOTTOM);
    
    }
    
    
    translate([0,0,H+H2+H3-DX])
    intersection()
    {
        selector();
    
        difference()
        {
        cyl(d1 = D3, d2 = D3, h = DX, anchor=BOTTOM);
        
        cyl(d1 = D3, d2 = D3-DX, h = DX+E, anchor=BOTTOM);
        
        }
    }
    
    translate([0,0,H+H2+H3])
    intersection()
    {
        selector();
        difference()
        {
        cyl(d1 = D3+2*W, d2 = D3+2*W, h = W, anchor=BOTTOM);
        
        cyl(d1 = D3-DX, d2 = D3-DX, h = W+E, anchor=BOTTOM);
        
        }
    }
}

}


perform_cut()
obj();
