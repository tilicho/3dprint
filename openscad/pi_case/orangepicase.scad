include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <orangepi_model.scad>
$fn=50;
ERR_PIN = 0.6;

SD = 2.7;
OX = 55;
OY = 50;
SIZE_X = OX + SD;
SIZE_Y = OY + SD;
SIZE_Z = 1.2;

BOT_SD = 3.2;//2.8;
BOTTOM_X = SIZE_X + BOT_SD;
BOTTOM_Y = SIZE_Y + BOT_SD;
BOTTOM_Z = SIZE_Z;

HOLE_X = 50;
HOLE_Y = 45;

DI = 3.2;
DO = 5.5;

W = 1.2;
E = 0.01;

PIN_BOTTOM = 4 + 2.1;

WALL_H = 5.7 + 2.1;
WD = 1.8;
WALL_X = OX + WD;
WALL_Y = OY + WD;

PIN_TOP = 12+1.2; //todo
WALL_TOP_H = PIN_TOP;

SHOW_BASE = false;
SHOW_BOTTOM = true;
SHOW_TOP = false;
CUT = false;


D_HOLE_TOP = 4.4;
H_HOLE_TOP = 2;
D_HOLE_BOT = 5;
H_HOLE_BOT = 1.8;

D_AIR = 8;
D_AIRB = 10;

D_ANT = 2.5;


AIRHOLES = true;

module perform_cut(cut=false)
{
    if (cut)
        back_half(s=200) children();
    else children();
}

module bottom()
{
translate([0,0,-PIN_BOTTOM-SIZE_Z])
diff()
{
    {
        cuboid([BOTTOM_X, BOTTOM_Y, BOTTOM_Z], rounding=5, edges="Z", anchor=BOTTOM)
        {
        align(TOP)
        {
        yflip_copy()
        xflip_copy()
        translate([HOLE_X/2, HOLE_Y/2, 0])
        zcyl(d=DO, h = PIN_BOTTOM-ERR_PIN, anchor=BOTTOM);
        
        };
        
        align(BOTTOM)
        {
        tag("remove")
        yflip_copy()
        xflip_copy()
        translate([HOLE_X/2, HOLE_Y/2, H_HOLE_BOT-E])
        zcyl(d=D_HOLE_BOT, h = H_HOLE_BOT);
        
        if (AIRHOLES)
        tag("remove")
        translate([0,0,BOTTOM_Z+E])
        zcyl(d=D_AIRB,h=BOTTOM_Z+E*2);
        }
        }
    }
    
    
    tag("remove")
    yflip_copy()
    xflip_copy()
    translate([HOLE_X/2, HOLE_Y/2, PIN_BOTTOM/2+BOTTOM_Z/2+E/2])
    zcyl(d=DI, h = PIN_BOTTOM+BOTTOM_Z+1+E);
    
}

}



module bottom_wall()
{
    dz = WALL_H - PIN_BOTTOM;
    ERR = 0.4;
    difference()
    {
        translate([0,0,-PIN_BOTTOM-SIZE_Z])
        translate([0,0,BOTTOM_Z])
        cuboid([WALL_X+2*W, WALL_Y+2*W, WALL_H], rounding=4, edges="Z", anchor=BOTTOM);
        
        translate([0,0,-PIN_BOTTOM-SIZE_Z])
        translate([0,0,BOTTOM_Z])
        cuboid([WALL_X, WALL_Y, WALL_H+E], rounding=4, edges="Z", anchor=BOTTOM);
    
        translate([0,WD,-ERR])
        orangepi_base(show_base=false, show_back_pin=false);
        
        translate([0,-WD,ERR])
        orangepi_base(show_base=false, show_back_pin=false);
    
        translate([0,-WALL_Y/2,dz])
        ycyl(d=D_ANT, h = 20);
        
        //translate([-WALL_X/2,0,dz])
        //xcyl(d=D_ANT, h = 20);
    }
}

module top_wall()
{
    ERR = 0.4;
    dz = WALL_H - PIN_BOTTOM;
    difference()
    {
    translate([0,0,dz])
    cuboid([WALL_X+2*W, WALL_Y+2*W, WALL_TOP_H], rounding=4, edges="Z", anchor=BOTTOM);
    
    translate([0,0,dz])
    cuboid([WALL_X, WALL_Y, WALL_TOP_H+E], rounding=4, edges="Z", anchor=BOTTOM);
    
    translate([0,WD,-ERR])
        orangepi_base(show_base=false, show_back_pin=false);
    
    
    translate([0,-WALL_Y/2,dz])
    ycyl(d=D_ANT, h = 20);
    
    //translate([-WALL_X/2,0,dz])
    //    xcyl(d=D_ANT, h = 20);
    }
}

module top()
{
    dz = WALL_H - PIN_BOTTOM-SIZE_Z;

    difference()
    {
    
    translate([0,0,PIN_TOP+dz   ])
    diff()
    {
    cuboid([BOTTOM_X, BOTTOM_Y, BOTTOM_Z], rounding=5, edges="Z", anchor=BOTTOM)
    {
    align(BOTTOM)
    {
        yflip_copy()
        xflip_copy()
        translate([HOLE_X/2, HOLE_Y/2, 0])
        zcyl(d=DO, h = PIN_TOP-ERR_PIN, anchor=BOTTOM);
    };
    align(TOP)
    {
        tag("remove")
        yflip_copy()
        xflip_copy()
        translate([HOLE_X/2, HOLE_Y/2, -H_HOLE_TOP+E])
        zcyl(d=D_HOLE_TOP,h=H_HOLE_TOP);
        
        if (AIRHOLES)
        tag("remove")
        translate([0,-10,-BOTTOM_Z-E])
        zcyl(d=D_AIR,h=BOTTOM_Z+E*2);
    }
    }
    }
    
    yflip_copy()
    xflip_copy()
    translate([HOLE_X/2, HOLE_Y/2, dz/2+ PIN_TOP/2 + BOTTOM_Z/2])
    zcyl(d=DI, h = PIN_TOP+BOTTOM_Z+E+dz);
    
    #translate([0,0,0.8])
    orangepi_base(show_base=false, show_back_pin=false);
    
    #translate([0,WD*2,0.8])
    orangepi_base(show_base=false, show_back_pin=false);
    
    translate([0,0,PIN_TOP/2])
    orangepi_base(show_base=false, show_only_pins=true);
    }
}


if (SHOW_BASE)
color("green")
 //translate([0,-WD,0])
orangepi_base(show_base=true,oversize_z=0);

perform_cut(CUT)
{
if(SHOW_BOTTOM)
{
bottom();
bottom_wall();
}

if (SHOW_TOP)
{
color("yellow")
top_wall();
top();
}

}