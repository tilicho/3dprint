include <BOSL2/std.scad>
include <BOSL2/screws.scad>

D1 = 45.0;//[0:0.1:250]
DY1 = 15.0;//[0:0.1:250]


D2 = 50.0;//[0:0.1:250]
DY2 = 15.0;//[0:0.1:250]

H = 65.0;//[0:0.1:200]

W = 1.2;//[0:0.1:200]
Wh = 1.2;//[0:0.1:200]
Hhat = 10.0;//[0:0.1:200]
E = 0.10;////[0:0.01:200]
R = 5.001;////[0:0.1:200]


$fn = 40;
CUT = false;
HAT = true;
BODY = true;

INNER_WALLS_COUNT = 4;

CUT_CIRCLE = true;

CIRCLE_D = 2.0 * (Hhat * 2.0 / 3.0);
CH_EXT = 2;

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

module round_facet(dx, dy, dz, r, chamfer=0)
{
    scale([1.01,1.01,1.01])
    difference()
    {
        translate([dx/2,dy/2,0])
        translate([-r/2,-r/2,0])
        cuboid([r, r, dz]);
        
        //tag("remove")
        translate([dx/2-r,dy/2-r,0])
        zcyl(r=r, h=dz+E*2, chamfer=chamfer);
    }
}

module facet_cube(dx, dy, dz, r, chamfer=CH_EXT)
{
    difference()
    {   
        cuboid([dx, dy, dz-E], 
            edges=[BOTTOM,TOP], 
            chamfer=CH_EXT);
        
        yflip_copy()
        xflip_copy()
        round_facet(dx,dy,dz,r-3, chamfer=chamfer);
    }
}



module rprismoid_ext(x1,y1,x2,y2,r,h, except=TOP)
{
    diff()
    {
    prismoid([x1, y1], [x2, y2], 
        h = h,
        //chamfer=CH_EXT,
        rounding=r
        )
    {
        airpods_edges_ext(except);
    }
    }

}


module obj()
{

if (BODY)
{
    difference()
    {

    //rprismoid_ext(D1, DY1, D2, DY2, R, H);
    prismoid([D1+2*W, DY1+2*W], 
             [D2+2*W, DY2+2*W], 
             rounding=R, h = H + E + W);
    
   
    //cyl(d = D2, d2 = D1, h = H);

    translate([0,0,W])
    prismoid([D1, DY1], 
             [D2, DY2], 
             rounding=R, h = H +W + E);
    
    //cyl(d = D2-2*W, d2 = D1-2*W, h = H);
/*
    if (CUT_CIRCLE)
    {
        
        translate([0, 0, H])
        rotate([90, 0, 0])
        cyl(d = CIRCLE_D, h = DY2 + 2 * E +2*W, $fn=6);
    }
  */
  
    }
    
    if (INNER_WALLS_COUNT)
    {
        INNER_WALLS_DX = (DY2) / (INNER_WALLS_COUNT);
        ycopies(INNER_WALLS_DX, INNER_WALLS_COUNT-1)
            cuboid([D2-E+2*W, W, H*2/3], anchor=BOTTOM);
    }
}

if (HAT)
{
    perform_rotate()
    translate([0,0,H - Hhat+2*Wh+E])//+ Wh*2])
    difference()
    {

    prismoid([D2 + E + 2*Wh+2*W, DY2 + E + 2*Wh+2*W],
            [D2 + E + 2*Wh+2*W, DY2 + E + 2*Wh+2*W], 
            rounding=R, h = Hhat+Wh);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    prismoid(
        [D2 + E+2*W, DY2 +E+2*W], 
        [D2 + E+2*W, DY2 +E+2*W], 
        rounding=R, h = Hhat+Wh);
    //cyl(d = D1 + E,  h = Hhat);

    }
}



}


perform_cut()
obj();

