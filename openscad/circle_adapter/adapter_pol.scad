include <BOSL2/std.scad>

$fn=40;
WALL=2.4;
DEXT=41.2;
DEXT_P=34.2;
H=20;
H1=20;
CUT=true;
DDIFF = 0.7;

module using_tube()
{
left_half()
{
diff()
tube(h=H, od=DEXT+WALL, wall=WALL, center=true)
{
    attach(TOP) tube(h=H, od=DEXT_P+WALL, wall = WALL, anchor=BOTTOM);
    attach(TOP) tube(h=WALL, od=DEXT+WALL, wall=WALL*2, anchor=BOTTOM);
}
}
}

module do_cut()
{
    if (CUT)
        left_half() children();
    else
        children();
}

module cham()
{   
    dd = DEXT + WALL * 3;
    //translate([0,0,-5])
    difference()
    {
    cyl(h=5-0.1, d=DEXT, anchor=BOTTOM, center=true);
    
    {
    diff()
    cyl(h=5, d=dd, anchor=BOTTOM, center=true)
    {
        move([0,0,-5])
        chamfer_cylinder_mask(chamfer=10, d=dd, anchor=BOTTOM, from_end=false);
    }
    }
    }
    

}

module obj()
{
    do_cut()
    {
        diff()
        cyl(h=H, d=DEXT + WALL)
        {
            tag("remove") cyl(h=H+0.1, d1=DEXT, d2=DEXT-DDIFF);
            attach(UP)
                {
                    diff()
                    cyl(h=H1, d=DEXT_P+WALL, anchor=BOTTOM);
                    tag("remove") cyl(h=H1+0.1, d2=DEXT_P, d1=DEXT_P-DDIFF, anchor=BOTTOM);
                };
            attach(UP)
                tube(h=WALL, od=DEXT+WALL, wall=WALL*2, anchor=BOTTOM);
            
         };
         
         translate([0,0,H/2-WALL])
         cham();
     }
}




obj();
//cham();