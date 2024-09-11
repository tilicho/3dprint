include <BOSL2/std.scad>

W = 20.4;
L = 25;
E = 0.001;
$fn=50;

WALL = 1.2;
D = 4.8;
HOLE_LEN = 20;

W_UP = 9;
H_UP = 13.2;

ADAPTER_CUBE = true;


module adapter()
{

diff()
{
    xflip_copy()
    cuboid([W+2*WALL,L,W+WALL], rounding=1,
        edges=ADAPTER_CUBE ? "Y" : "Z",
        except=TOP
        )
    align(TOP+LEFT)
    {
    tag("KEEP")
    translate([0,0,0])
    cuboid([W_UP+WALL,L,H_UP], rounding=1,
        edges=ADAPTER_CUBE ? "Y" : "Z", except=BOTTOM);
    
    translate([W_UP/4+WALL,0,-WALL-E])
    tag("remove")
    zcyl(d=D,l=HOLE_LEN);
    
    }
    
    if (ADAPTER_CUBE)
    {
    tag("remove")
    translate([0,0,-WALL])
    cuboid([W,L+E,W+WALL+E]);
    }
    else
    {
    tag("remove")
    translate([0,0,-WALL/2])
    cuboid([W+WALL*2+E,L+E,W+WALL+E]);
    }
}
}
/*
difference()
{
cuboid([W+2*WALL,L,W+2*WALL], rounding=1,
        edges="Y",
        except=TOP
        );
        
translate([0,0,-WALL/2])
    cuboid([W,L,W+WALL]);        
}*/

rotate([90,0,0])
adapter();