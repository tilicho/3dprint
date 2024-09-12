include <BOSL2/std.scad>
D1 = 60;
DY1 = 60;
H = 20;
R = 20;
CH_EXT = 3;
$fn = 50;
E = 0.1;

module round_facet(dx, dy, dz, r, chamfer1=0, chamfer2=0)
{
    scale([1.01,1.01,1])
    difference()
    {
        translate([dx/2,dy/2,0])
        translate([-r/2,-r/2,0])
        cuboid([r, r, dz]);
        
        //tag("remove")
        translate([dx/2-r,dy/2-r,0])
        zcyl(r=r, h=dz+E*2, chamfer1=chamfer1, chamfer2=chamfer2);
    }
}

module facet_cube(dx, dy, h = 10, 
    rounding=20, 
    chamfer1=0,
    chamfer2=0)
{
    difference()
    {   
        edges = (chamfer1 && chamfer2) ? [BOTTOM, TOP] : 
            (chamfer1 ? [BOTTOM] : [TOP]);
            
        cuboid([dx, dy, h-E], 
            edges=edges, 
            chamfer=CH_EXT);
        
        yflip_copy()
        xflip_copy()
        round_facet(dx,dy,h,rounding, chamfer1=chamfer1, chamfer2=chamfer2);
    }
}

facet_cube(D1, DY1, h = H, rounding = R, 
    chamfer2=CH_EXT);