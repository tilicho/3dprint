include <BOSL2/std.scad>
include <BOSL2/screws.scad>
SCREW_LEN = 15;
SCREW_D = "M15x3.5";
SLOP_SCREW = 0.05;
HEAD_H = 10;
$fn=50;
CYL_PATTERN = "cubes";

SPHERE_D = 13;
CYL_D = 10;
CYL_L = 8;
CUT = false;
E = 0.01;

SLOP_HOLE = 0.2;//0.2 for vertical
NUT_THREAD = SCREW_D;//"M15x3.5";

PLAT_Z = 10;
PLAT_D = 18;

PLAT_D2 = 30;
PLAT_Z2 = 3;
PLAT_SLOOP = 0.4;

NUT_L = 25;

module m18_screw(
    screw_len=SCREW_LEN,
    thread_len=-1,
    head_size=22,
    head_h = HEAD_H,
    head_type="none",
    cyl_head=true,
    cyl_pattern=CYL_PATTERN,
    top_chphere=true,
    bevel=false)
{
    thread = str(SCREW_D, ",", str(screw_len));

    spec = screw_info(thread,head=head_type);
    newspec = struct_set(spec,[
        "head_size",head_size,
        "head_height",head_h]
        );

    rotate([0,180,0])
    screw(newspec, 
        //tolerance="6e", 
        thread_len=thread_len >= 0 ? thread_len : screw_len, 
        atype="shaft",
        undersize=SLOP_SCREW,
        bevel1=bevel,
        bevel2=false)
    {
    
    align(TOP)
    {
        if (cyl_head)
            diff()
            {
                cyl(d= head_size, h = head_h, texture=cyl_pattern, tex_size=[4,4])
                tag("remove")
                {
                    align(CENTER)
                    zflip_copy()
                    up(head_h/2)
                    chamfer_cylinder_mask(d=head_size+2, chamfer=1);
                }
            }
    };
    
    
    align(BOTTOM)
    {
        if (top_chphere)
        {
//           down(-SPHERE_D/5)
          sphere(d=SPHERE_D);
          cyl(d = CYL_D, l = SPHERE_D/2);
        }
    };
    
    }
}


module platform()
{
    diff()
    {
        //cuboid([PLAT_X, PLAT_Y, PLAT_Z])
        cyl(d = PLAT_D, l = PLAT_Z, chamfer1=1)
        {
        align(BOTTOM)
        tag("remove")
        translate([0,0,SPHERE_D*4/5])
        sphere(d= SPHERE_D+PLAT_SLOOP);
        
        align(TOP)
        cyl(d= PLAT_D2, l = PLAT_Z2, chamfer2=1);
        }
        
        tag("remove")
        zrot_copies([0, 90])
        cuboid([PLAT_D, 2, PLAT_Z+E]);
    }
}

module hole(hole_len, thread=true, slop=SLOP_HOLE,
    teardrop=false, bevel=true, anchor=CENTER)
{
    if (thread)
        screw_hole(NUT_THREAD, l=hole_len
                  , head="none", 
                  thread=thread,  
                  tolerance="8G", 
                  $slop=slop,
                  teardrop=teardrop,
                  bevel=bevel,
                  anchor=anchor
                  );
    else
        screw_hole(NUT_THREAD, l=hole_len, head="none", 
                  thread=false,  
                  //tolerance="8G", 
                  $slop=slop,
                  anchor=anchor);
}

module perform_cut(cut=false)
{
    if (cut)
        front_half(s=200) children();
    else children();
}


m18_screw();

perform_cut(CUT)
translate([0,0,SCREW_LEN*4])
platform();

translate([0,0,SCREW_LEN*2.5])
difference()
{
    cuboid([NUT_L, NUT_L, 5], rounding=3, edges="Z");
    hole(10+E);
}