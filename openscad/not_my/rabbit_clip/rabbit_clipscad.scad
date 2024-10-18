include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

WALL = 1.8;

H = 3.6;
DH = 0.6;

W = 20;
DW = 3;

LEN = 20;

R = 10.5;//13.5/25 * W; 


SNAP = 2;
LOCK_CLEARENCE = 4.5;
THICKNESS = 1.2;
COMPRESSION = 0.5;

CUT = true;
FEMALE = true;
MALE = true;

MALE_DZ = 11;
MALE_R = 1;
$fn = 50;
MALE_H_W = 3.5;
MALE_H2_ANGLE = 10;
E = 0.4;


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

module cyl_hole(l = W, d = W/3, w = MALE_H_W, h = 20)
{
    E = 0.1;
    ll = l / 2;
    
    x2 = (ll * ll + d * d);
    rr = x2 / (2*d);
    alpha = acos(d / sqrt(x2));
    betta = (90 - alpha) * 4;
    
    y = rr - d;

    translate([0,-y,0])
    rotate([0,0,90-betta/2])
    difference()
    {
        pie_slice(r=rrw, 
                ang=betta, l=h, anchor=CENTER);
        pie_slice(r=rr-w, ang=betta+0.001, l=h+E, anchor=CENTER);
    }
}

module clip()
{
if (MALE)
{
    MALE_DY = H + DH/2 + WALL;
    MALE_DY_TRANSLATE = (MALE_DY - H)/2;
    H_T = MALE_DZ/4;
    //perform_rotate()
    {
        {
        translate([0,MALE_DY_TRANSLATE,-MALE_DZ/2])
            difference()
            {
            cuboid([W+WALL,MALE_DY, MALE_DZ ],
                rounding=MALE_R, edges = "Y");
            
            translate([0,0,H_T])
            cuboid([W,W,MALE_H_W], rounding=MALE_R, edges="Y");
            
            translate([0,0,-H_T])
            rotate([-MALE_H2_ANGLE,0, 0])
            cuboid([W,W,MALE_H_W], rounding=MALE_R, edges="Y");
            }
        }
//    attach(BACK)
        {
        rabbit_clip("pin", 
            length=LEN, 
            width=W, 
            thickness=THICKNESS, 
            snap=SNAP, 
            compression=COMPRESSION, 
            lock=true, 
            depth=H, 
            lock_clearance=LOCK_CLEARENCE);
        }

    }
}


if (FEMALE)
{
//color("red")
difference()
{
diff()
{
    cuboid([W + WALL,
            LEN+2*WALL, 
            H + DH + 2*WALL],
            orient=BACK,
            anchor=BACK,
            rounding=MALE_R, edges = "Y")
    {
        tag("remove")
        attach(BACK)
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
        tag("remove")
        zcyl(l=20,r=R, $fn=64);
        
    }
};

translate([0,0,LEN+COMPRESSION])
cuboid([W+WALL,H+DH+2*WALL,LEN/2],
    rounding=MALE_R, edges="Z", anchor=BOTTOM);
}


translate([0,0,LEN+COMPRESSION])
difference()
{
cuboid([W+WALL,H+DH+2*WALL,LEN/2],
    rounding=MALE_R, edges="Z", anchor=BOTTOM);

translate([0,0,LEN/4+MALE_H_W/2+WALL/2])
rotate([90,180,0])
cyl_hole();
} 
   
}

}





perform_cut()
clip();

//rotate([90,0,0])
//cyl_hole();