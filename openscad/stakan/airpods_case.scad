include <BOSL2/std.scad>
include <BOSL2/screws.scad>

W = 1.2;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
WdiffH = 0.6;
WhBot = 1.2;
E = 0.3;////[0:0.1:100]

DXE = 1.5;
DYE = 1.5;

D1 = 61 + DXE;//[0:0.1:100]
DY1 = 21.8 + DYE;//[0:0.1:100]


D2 = D1;//[0:0.1:100]
DY2 = DY1;//[0:0.1:100]

H_ = 45.4;
H = H_ + Wh * 2 + E;//[0:0.1:100]

Hhat = 13;//[0:0.1:100]

R = 5;////[0:0.1:100]
$fn = 50;
CUT = true;
HAT = true;
BODY = true;
PODS = false;


CIRCLE_D = 2.0 * (Hhat * 2.0 / 3.0);

CH = 13;
CH2 = 10;
CH_EXT = 3;

module perform_cut()
{
    if (CUT)
        front_half(s=200) children();
    else children();
}

module perform_rotate(rot)
{
    if (!rot)
        children();
    else
    {
        if (HAT && !BODY)
            rotate([180,0,0]) children();
        
        else children();
    }
}

module airpods_edges(except=TOP)
{
    edge_profile(
        "Y",
        except=except,
        //[TOP+RIGHT, BOT+FRONT], 
            excess=2, convexity=2) {
        mask2d_roundover(h=CH,mask_angle=$edge_angle);
    }
    
    edge_profile(
        "X",
        except=except,
        //[TOP+RIGHT, BOT+FRONT], 
            excess=2, convexity=2) {
        mask2d_roundover(h=CH2,mask_angle=$edge_angle);
    }
}

module airpods_edges_ext(except=TOP)
{
    edge_profile(
        "Y",
        except=except,
        //[TOP+RIGHT, BOT+FRONT], 
            excess=2, convexity=2) {
       mask2d_chamfer(x=CH_EXT); //mask2d_roundover(h=CH_EXT,mask_angle=$edge_angle);
    }
    
    edge_profile(
        "X",
        except=except,
        //[TOP+RIGHT, BOT+FRONT], 
            excess=2, convexity=2) {
       mask2d_chamfer(x=CH_EXT);
       //mask2d_roundover(h=CH_EXT,mask_angle=$edge_angle);
    }
    
    corner_mask(except=except)
        chamfer_corner_mask(chamfer=CH_EXT);
        //rounding_corner_mask(r=CH_EXT*2);
}

module rprismoid(x1,y1,x2,y2,r,h, except=TOP)
{
    diff()
    {
    prismoid([x1, y1], [x2, y2], rounding=CH2, h = h)
    {
        airpods_edges(except);
    }
    }

}

module rprismoid_ext(x1,y1,x2,y2,r,h, except=TOP)
{
    diff()
    {
    prismoid([x1, y1], [x2, y2], 
        h = h,
        chamfer=CH_EXT
        //rounding=CH2
        )
    {
        airpods_edges_ext(except);
    }
    }

}

module rprismoid2(x1,y1,x2,y2,r,h, except=BOTTOM)
{
    rprismoid_ext(x1,y1,x2,y2,r,h,except);
}

module body()
{
    difference()
    {

    rprismoid_ext(D1+2*W, DY1+2*W, D2+2*W, DY2+2*W, R, H);
    
    
    translate([0,0,W])
             
    rprismoid(D1, DY1, 
             D2, DY2, 
             R, H + E);
             
    translate([0,0,H-WhBot-CH_EXT])
    cuboid([D1 + 2*W, DY1 + 2*W, CH_EXT], anchor=BOTTOM);
    
    
    }
}

module hat(rot=true,except=EDGES_ALL)
{

    e = rot ? E : 0;
    space = rot ? 0 : 10;
    
    perform_rotate(rot)
    translate([0,0,H - Hhat])//+ Wh*2])
    difference()
    {
    d2ext = e + 2*WdiffH + space + 2*Wh;

    rprismoid2(
        D2 + d2ext, DY2 + d2ext,
        D2 + d2ext, DY2 + d2ext, 
        R, Hhat);//, except);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    d2ext2 = e + 2*WdiffH;
    
    translate([0,0,-WhBot])
    rprismoid2(
        D2 + d2ext2, DY2 +d2ext2, 
        D2 + d2ext2, DY2 +d2ext2, 
        R, Hhat);//, except);
    //cyl(d = D1 + E,  h = Hhat);

    }

}

module airpods()
{
    #
    
    translate([0,0,Wh])
    diff()
    {
        cuboid([D1-DXE, DY1-DYE, H_], anchor=BOTTOM,
            rounding=CH2, 
            edges="Z"
        )
        {
        airpods_edges([]);
        }
    }
}




perform_cut()
{
if (BODY)
    difference()
    {
        body();
        hat(false);
    };

if (HAT)
    color("green")
    hat();

if (PODS)
    airpods();

}
