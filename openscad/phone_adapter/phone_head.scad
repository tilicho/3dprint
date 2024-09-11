include <BOSL2/std.scad>
include <BOSL2/screws.scad>
use <../screws/screw_mount.scad>
use <../screws/m12.scad>
use <iphone_to_3dcam.scad>

X = 20;
Y = 40;
Z = 40;

W = 5;

E = 0.01;
$fn=50;

BASE_D = 12;//12;
BASE_DI = 9;
BASE_W = 5;//5;
BASE_H = 13;
BASE_SHIFT_LEG = 3;
SLOP=0.1;

module wall()
{
        diff()
        {
            cuboid([X+2*W,W,BASE_D], rounding=2, edges="Y", except=TOP);
            
            tag("remove")
            rotate([90,0,0])
            hole(W+E, anchor=CENTER);
        }

}
module phone_head()
{
diff()
{
    cuboid([X+2*W,Y,Z+W], rounding=2, edges="Y")
    
    
    up(W/2)
    tag("remove")
    cuboid([X,Y+E,Z+E], rounding=2, edges="Y", except=TOP);
    
    
    rotate([180,0,0])
    left(X-W*3/2)
    rotate([0,90,0])
    m12hole(W*2+E, teardrop=true);
}

//down(Z/2+BASE_D/2+W/2-2)
//wall();

translate([0,Y/2+0.2,0])
down(Z/2+BASE_D)
rotate([0,90,0])
connection(
        h = BASE_H, 
        dx = BASE_D + BASE_SHIFT_LEG*1.5, 
        dy = BASE_W, 
        threaded=true, 
        anchor=CENTER,
        show=[2], 
        rot_cyl=0,
        slop=SLOP);
}

rotate([-90,0,0])
phone_head();

