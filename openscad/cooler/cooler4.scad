include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <../screws/screw_mount.scad>

COOLER_SIZE = 120.4;
COOLER_HOLE_L = 105;
COOLER_H = 25.4;
COOLER_D = 4;
COOLER_R = 6;

$fn=50;
E = 0.1;

SIZE_E = 0.4;
COOLER_ATTACH_WZ = 1.8;
COOLER_ATTACH_WSIZE = 15;

COOLER_ATTACH_CORNER_W = 8;
COOLER_ATTACH_HEX_W = 5;

SHOW_COOLER = false;
PRINT_ATTACH = false;
PRINT_FRAME = true;

FRAME_W = 5;
FRAME_Y = 80;
FRAME_R = 2;


dx = COOLER_ATTACH_WSIZE/2 - (COOLER_SIZE - COOLER_HOLE_L)/2;
cooler_real_h = COOLER_H+COOLER_ATTACH_WZ*2+SIZE_E*2+COOLER_R/3;
module cooler()
{
    color("green")
    difference()
    {
    cuboid([COOLER_SIZE, COOLER_SIZE, COOLER_H],
    rounding=COOLER_R, edges="Z");
    
    yflip_copy()
    xflip_copy()
    translate([COOLER_HOLE_L/2, COOLER_HOLE_L/2,0])
    zcyl(d=COOLER_D, h=COOLER_H+E);
    }
    
    
}


module cooler_attach()
{
    color("blue")
    {
    
    zflip_copy()
    yflip_copy()
    translate([COOLER_HOLE_L/2, COOLER_HOLE_L/2,COOLER_H/2+SIZE_E])
    
    difference()
    {
    translate([SIZE_E, 0,0])
    cuboid([COOLER_ATTACH_WSIZE,COOLER_ATTACH_WSIZE,COOLER_ATTACH_WZ],rounding=COOLER_R,
                  edges=["Z"],
        except=RIGHT,
        anchor=BOTTOM);
    
    zcyl(d=COOLER_D, h=COOLER_H+E);
    };
    
    translate([COOLER_SIZE/2+SIZE_E/2, 0,0])
    {
        diff()
        {
            cuboid([COOLER_ATTACH_CORNER_W,
                COOLER_SIZE+dx*2+COOLER_R/3,
                cooler_real_h],
                anchor=LEFT,
                rounding=COOLER_R/2,
                edges=["X"],
                except=LEFT)
            attach(RIGHT)
            {
                tag("remove")
                translate([0,0,
                    //0])
                    -COOLER_ATTACH_CORNER_W-E])
                rotate([90,0,0])
                hole_hex(
                    COOLER_ATTACH_HEX_W,
                    dint = 10.5, 
                    anchor=FRONT);
                    
                
                tag("remove")
                translate([0,0,-COOLER_ATTACH_CORNER_W/2])
                hole(
                    COOLER_ATTACH_CORNER_W+E, thread=false);
                
            }
        }
    }
    
    }
}

module cooler_frame()
{
    color("green")
    difference()
    {
        {
            xflip_copy()
            difference()
            {
            translate([COOLER_SIZE/2+SIZE_E + COOLER_ATTACH_CORNER_W
                ,10,0])
            cuboid([FRAME_W, FRAME_Y+FRAME_W, 
                cooler_real_h],
            rounding=FRAME_R,
                    edges=["Z"],
                    anchor=LEFT+BACK)
            attach(FRONT)
            {
                translate([FRAME_W/2,0,-FRAME_W/2])
                {
                cuboid([COOLER_SIZE, cooler_real_h, FRAME_W],
                rounding=FRAME_R,
                        edges=["Y"],
                        anchor=RIGHT);
                        
                translate([-2*FRAME_W/2,0,-FRAME_W/2])
                rotate([0,0,180])
                fillet(l = cooler_real_h, r = FRAME_R, orient=BACK);  
                }
            };
            
            
            translate([COOLER_SIZE/2+SIZE_E + COOLER_ATTACH_CORNER_W+FRAME_W/2,
                0,0])
            rotate([0,0,90])
            hole_hex(
                FRAME_W,
                dint = 8.6, 
                anchor=CENTER);
            }
        };
        
        translate([0
            ,-COOLER_SIZE/2-COOLER_ATTACH_CORNER_W/2-SIZE_E-10
            ,0])
            hole_hex(
                cooler_real_h*2,
                dint = 8.6, 
                anchor=CENTER);
    };
}

module if_print(print=true)
{
    if (!print)
    xflip_copy() children();
    else
    rotate([0,90,0])
    children();
}

module screw_frame()
{
screw_(screw_len=(COOLER_ATTACH_CORNER_W-COOLER_ATTACH_HEX_W)+FRAME_W+5+1,  
    head_size=9.8, 
    head_h=COOLER_ATTACH_HEX_W-1, 
    head_type="hex", 
    cyl_head=false);
}

module nut_frame()
{
nut_(nut_h=3, chamfer=false);
}

if (SHOW_COOLER)
#cooler();

if_print(PRINT_ATTACH) cooler_attach();

cooler_frame();

screw_frame();
!nut_frame();