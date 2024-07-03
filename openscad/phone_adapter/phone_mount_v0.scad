include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <../screws/screw_mount.scad>
use <iphone_to_3dcam.scad>

$fn = 50;
E = 0.1;

BASE = true;
LEGS = true;
LEG = false;
TOP_HEAD = true;
SHOW_MODEL = true;
SCREW = false;
SCREW2 = false;

BASE_D = 13;//12;
BASE_DI = 9;
BASE_W = 5;//5;
BASE_H = 13;

BASE_SHIFT_LEG = 3;


SLOP=0.1;

CUBE_X = 15;
RC = 1;
BASE_D_C_ = 8.2;

LEG_L = 50;
LEG_SHIFT_X = 3;



TOP_D = 20;
TOP_H1 = 7;
TOP_HOLE_H = 5;
//TOP_BASE_H = BASE_H;



MODEL = "IPhone13";
PHONE_W = 2.4;



D_C = BASE_D_C_ / cos(180/6);


module perform_cut(cut=false)
{
    if (cut)
        front_half(s=200) children();
    else children();
}

module base()
{

difference()
{
cyl(d= BASE_D, l=BASE_H);
hole(hole_len=BASE_H+E, thread=false);
//cyl(d = BASE_DI, l=BASE_H+E);
}

#zrot_copies(n=3)
translate([BASE_D/2-RC+BASE_SHIFT_LEG+0.5, 0, 0])
connection(h=BASE_H, 
        dx = BASE_D + BASE_SHIFT_LEG+2, 
        dy = BASE_W, 
        threaded=false, show=[2], anchor=RIGHT);

/*{
    difference()
    {
        cuboid([CUBE_X, BASE_W, BASE_H], anchor=LEFT, rounding=RC, edges="Z");

        //translate([CUBE_X/2,0,0])
        //    yrot(180/6)
        //        ycyl(d = D_C, l=BASE_W+E, $fn=6);
    }
}*/

}


module leg()
{
    connection(
        h=BASE_H, 
        dx = BASE_H+LEG_SHIFT_X, 
        dy = BASE_W, 
        threaded=true, 
        show=[2], 
        anchor=LEFT, 
        slop=SLOP);

    translate([-BASE_H-LEG_SHIFT_X+2,0,0])
    rotate([0,90,0])
    {
        diff()
        {
        prismoid([BASE_H/4,BASE_W*2],
                [BASE_H+0.5,BASE_W*2]
                    ,h=LEG_L
                    ,shift=[-BASE_H/4,0]
                    , anchor=TOP)
            {
            
            edge_profile(
                "Y",
                //except=TOP,
                //[TOP+RIGHT, BOT+FRONT], 
                    excess=2, convexity=2) 
                {
                    mask2d_roundover(h=2,mask_angle=$edge_angle);
                }
            }
        }
    }
        
}

module top()
{
    dz = (-TOP_H1 + TOP_HOLE_H);
    
    diff()
    {
    cyl(d2 = TOP_D+2, d1 = BASE_H+4, h = TOP_H1,
        chamfer2=2,
        anchor=CENTER)
        
    tag("remove")
    translate([0,0,TOP_H1/2-(TOP_H1-TOP_HOLE_H)-E])
    cyl(d1=9,d2=1,h=TOP_H1 - TOP_HOLE_H,
        anchor=BOTTOM);
    
    
    tag("remove")
    translate([0,0, dz/2-E])
    hole(TOP_HOLE_H);
    }
    
    translate([0,0,TOP_H1/2+BASE_SHIFT_LEG/2])
    rotate([0,90,0])
    connection(h=BASE_H+2, 
        dx = BASE_D + BASE_SHIFT_LEG+2, 
        dy = BASE_W, 
        threaded=false, 
        show=[1], 
        anchor=RIGHT, 
        rot_cyl=0);
    
}

module phone_mount(model="Iphone13")
{
h = BASE_H;
//iphone_mount(model=model, h=h, w=PHONE_W, epx=0.3, epz=0.2);
cube_h = 50;
MOUNT_L = 30;

difference()
{
iphone_mount(model=model, h=h, w=PHONE_W, epx=0.3, epz=0.2);

translate([
    get_phone_x(MODEL)/2+PHONE_W/2-cube_h/2-MOUNT_L
    ,0,0])
cuboid(cube_h);
}

translate([
    get_phone_x(MODEL)/2+PHONE_W/2+BASE_D 
    + BASE_SHIFT_LEG*1.5, 
    //-(h/2)+BASE_W,
    //-BASE_W/2+BASE_W/2, 
    -(h/2)+E*2+BASE_W,
    0])
connection(
        h = BASE_H, 
        dx = BASE_D + BASE_SHIFT_LEG*1.5, 
        dy = BASE_W, 
        threaded=true, 
        show=[2], 
        anchor=LEFT, 
        rot_cyl=0,
        slop=SLOP);
}


if (BASE)
base();

if (LEGS && !LEG)
rotate([0,0,60])
zrot_copies(n= BASE && LEGS ? 3 : 1)
translate([-BASE_D/2+RC-BASE_SHIFT_LEG, 0, 0])
leg();

if (LEG)
translate([-BASE_D/2+RC-BASE_SHIFT_LEG, 0, 0])
rotate([90,0,0])
leg();

if (TOP_HEAD)
translate([0, 0, BASE_H])
perform_cut(false)
top();

if (SCREW)
rotate([0,180,0])
screw_(screw_len=BASE_H+TOP_H1);

if (SCREW2)
rotate([0,180,0])
screw_(screw_len=BASE_W*2+2);


if (SHOW_MODEL)
translate([0, 0, get_phone_x(MODEL)+BASE_SHIFT_LEG*1.5+2])
rotate([0,90,0])
perform_cut(false)
phone_mount(model=MODEL);
