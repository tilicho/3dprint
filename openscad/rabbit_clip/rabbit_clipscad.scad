include <BOSL2/std.scad>
include <BOSL2/joiners.scad>

WALL = 1.2;

H = 5;
DH = 1.6;

W = 26.6;
DW = 3;

LEN = 20;
LEN2 = 19;

R = 10.5;//13.5/25 * W; 


SNAP = 2;
LOCK_CLEARENCE = 7.5;//4.5;
THICKNESS = 1.2;
COMPRESSION = 0.5;

CUT = false;
FEMALE = true;
MALE = true;

MALE_DZ = 21;
MALE_R = 1;
$fn = 50;
MALE_H_W = 4.3;
MALE_H2_ANGLE = 10;
E = 0.4;

LEN3 = 12;

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

module cyl_hole(l = W-WALL*2, d = W/4, w = MALE_H_W, h = 20)
{
    E = 0.1;
    ll = l / 2;
    
    x2 = (ll * ll + d * d);
    rr = x2 / (2*d);
    alpha = acos(d / sqrt(x2));
    betta = (90 - alpha) * 4;
    
    y = rr - d;
    FN = 6;

    translate([0,-y,0])
    rotate([0,0,90-betta/2])
    difference()
    {
        pie_slice(r=rr, 
                ang=betta, l=h, anchor=CENTER,
                $fn=FN);
        pie_slice(r=rr-w, ang=betta+0.001, l=h+E, anchor=CENTER, $fn=20);
    }
}

module female()
{
difference()
{
diff()
{
    cuboid([W + 2*WALL,
            LEN2+2*WALL, 
            H + DH + 2*WALL],
            orient=BACK,
            anchor=BACK,
            rounding=MALE_R, edges = "Y")
    {
        tag("remove")
        attach(BACK)
        rabbit_clip("socket", 
            length=LEN2, 
            width=W, 
            thickness=THICKNESS+1, 
            snap=SNAP, 
            compression=COMPRESSION, 
            lock=true, 
            depth=H+DH, 
            lock_clearance=LOCK_CLEARENCE);
        
        //xflip_copy()
        //position(FRONT+LEFT)
        //xscale(0.8)
        //tag("remove")
        //zcyl(l=20,r=R*0.75, $fn=8);
        
    }
};

//translate([0,0,LEN2+COMPRESSION])
//cuboid([W+WALL,H+DH+2*WALL,LEN/2],
//    rounding=MALE_R, edges="Z", anchor=BOTTOM);
}


translate([0,0,LEN+COMPRESSION])
difference()
{
cuboid([W+WALL,H+DH+2*WALL,LEN3],
    rounding=MALE_R, edges="Z", anchor=BOTTOM);

translate([0,0,LEN3/2+MALE_H_W/2])
rotate([90,180,0])
cyl_hole();

//xflip_copy()
//translate([W/2+WALL/2,0,0])
//ycyl(l=20,r=R/2,$fn=8);
} 
   
}


module clip()
{
if (MALE)
{
    MALE_DY = H + WALL+DH/2;
    MALE_DY_TRANSLATE = (MALE_DY - H)/2;
    H_T = MALE_DZ/4;
    //perform_rotate()
    color("red")
    {
        {
        translate([0, 
                   MALE_DY_TRANSLATE,
                   -MALE_DZ/2])
            difference()
            {
            cuboid([W+2*WALL,MALE_DY, MALE_DZ ],
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
            length=LEN*1.1, 
            width=W, 
            thickness=1.5,//THICKNESS, 
            snap=2,//SNAP, 
            compression=0.6,//COMPRESSION, 
            lock=true, 
            depth=H, 
            lock_clearance=3 //LOCK_CLEARENCE
            );
        }

    }
}


if (FEMALE)
{

difference()
{
female();

translate([0,0,LEN2])
xflip_copy()
translate([W/2+WALL/2+1,0,0])
ycyl(l=20,r=R/1.2,$fn=4);

}


}

}




perform_cut()
clip();

//rotate([90,0,0])
//cyl_hole();