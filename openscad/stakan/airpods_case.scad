include <BOSL2/std.scad>
include <BOSL2/screws.scad>

W = 2.4;//[0:0.1:100]
Wh = 1.2;//[0:0.1:100]
E = 0.1;////[0:0.1:100]

DXE = 1.5;
DYE = 1.5;

D1 = 60.0 + DXE;//[0:0.1:100]
DY1 = 21.2 + DYE;//[0:0.1:100]


D2 = D1;//[0:0.1:100]
DY2 = DY1;//[0:0.1:100]

H_ = 45.4;
H = H_ + Wh * 2 + E;//[0:0.1:100]

Hhat = 13.0;//[0:0.1:100]

R = 5;////[0:0.1:100]
$fn = 50;
CUT = true;
HAT = true;
BODY = true;
PODS = true;


CIRCLE_D = 2.0 * (Hhat * 2.0 / 3.0);

CH = 13;
CH2 = 10;
CH_EXT = 5;

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
        mask2d_roundover(h=CH_EXT,mask_angle=$edge_angle);
    }
    
    edge_profile(
        "X",
        except=except,
        //[TOP+RIGHT, BOT+FRONT], 
            excess=2, convexity=2) {
        mask2d_roundover(h=CH_EXT,mask_angle=$edge_angle);
    }
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
    prismoid([x1, y1], [x2, y2], rounding=CH2, h = h)
    {
        airpods_edges_ext(except);
    }
    }

}

module rprismoid2(x1,y1,x2,y2,r,h, except=BOTTOM)
{
    
    prismoid([x1, y1], [x2, y2], rounding=CH2, h = h);
   

}

module body()
{
    difference()
    {

    rprismoid_ext(D1+2*W, DY1+2*W, D2+2*W, DY2+2*W, R, H);
    
    //cyl(d = D2, d2 = D1, h = H);

    translate([0,0,W])
    /*prismoid([D1-2*W, DY1 - 2*W], 
             [D2 - 2*W, DY2 - 2*W], 
             rounding=R, h = H + E);*/
             
    rprismoid(D1, DY1, 
             D2, DY2, 
             R, H + E);
    
    //cyl(d = D2-2*W, d2 = D1-2*W, h = H);

    
    
    }
}

module hat(rot=true,except=EDGES_ALL)
{

    e = rot ? E : 0;
    perform_rotate(rot)
    translate([0,0,H - Hhat])//+ Wh*2])
    difference()
    {

    rprismoid2(D2 + e + 2*W, DY2 + e + 2*W,
            D2 + e +2*W, DY2 + e +2*W, 
            R, Hhat, except);
    //cyl(d = D1 + E + 2*Wh, h = Hhat);

    translate([0,0,-Wh])
    rprismoid2(
        D2 + e+2*W - 2*Wh, DY2 - 2*Wh +e+2*W, 
        D2 + e+2*W - 2*Wh, DY2 +e+2*W - 2*Wh, 
        R, Hhat, except);
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
