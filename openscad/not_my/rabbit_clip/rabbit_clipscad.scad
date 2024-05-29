include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

WALL = 1.8;

H = 3.6;
DH = 0.6;

W = 20;
DW = 3;

LEN = 20;

R = 13.5/25 * W; 


SNAP = 2;
LOCK_CLEARENCE = 4.5;
THICKNESS = 1.2;
COMPRESSION = 0.5;

CUT = true;
FEMALE = true;
MALE = true;



module perform_cut()
{
    if (CUT)
        back_half(s=200) children();
    else children();
}

module perform_rotate()
{
    if (MALE && !FEMALE && !CUT)
        rotate([90,0,0])
            children();
    else 
        children();
}

module clip()
{
if (MALE)
perform_rotate()
cuboid([W,5,H],anchor=BACK, orient=FRONT)
    attach(BACK)
    rabbit_clip("pin", 
            length=LEN, 
            width=W, 
            thickness=THICKNESS, 
            snap=SNAP, 
            compression=COMPRESSION, 
            lock=true, 
            depth=H, 
            lock_clearance=LOCK_CLEARENCE);

if (FEMALE)
color("red")
diff("remove")
cuboid([W + WALL,LEN+2*WALL, H + DH + 2*WALL],orient=BACK,anchor=BACK){
    tag("remove")attach(BACK)
        rabbit_clip("socket", 
            length=LEN, 
            width=W, 
            thickness=THICKNESS, 
            snap=SNAP, 
            compression=COMPRESSION, 
            lock=true, 
            depth=H+DH, 
            lock_clearance=LOCK_CLEARENCE);
    xflip_copy()
      position(FRONT+LEFT)
      xscale(0.8)
      tag("remove")zcyl(l=20,r=R, $fn=64);
}
}

perform_cut()
clip();