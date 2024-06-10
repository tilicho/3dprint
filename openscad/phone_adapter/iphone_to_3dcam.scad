include <BOSL2/std.scad>
include <BOSL2/screws.scad>
$fn = 100;
CUT = false;
D = 3;
D_dist = 47.5;
D_dist2 = 10;
W = 2.4;
H = 3;//10;
R = 1;
E = 0.1;
EPX = 0.2;
EPZ = 0.4;

HoleZ = 2;
HoleD = 5;

Phone_x_ = 64.4;//59;
Phone_z_ = 8.2;//7.7;
Phone_offset = 29;



Phone_x = Phone_x_ + EPX;
Phone_z = Phone_z_ + EPZ;

HookX1 = 24;
HookX2 = 27;
HookX3 = 10;

module iphone_mount()
{
    difference()
    {
    cuboid([Phone_x+2*W, H, Phone_z+2*W],
        rounding=R, edges="Y" 
        //,except=[[-1, 1, -1]]
        );
    cuboid([Phone_x, H+E, Phone_z]
        );
    }
}

module iphone_3dprint()
{
    iphone_mount();

    translate([-Phone_x/2-W-HookX1/2-W/2, 0, -Phone_z/2-W/2])
    {
    cuboid([HookX1+W, H, W], rounding=R,
        edges = [-1,0,1]);

    translate([W/2-HookX1/2-W/2, 0, -HookX2/2-W/2])
    {
    #cuboid([W, H, HookX2]);


    translate([HookX3/2+W/2, 0, -HookX2/2-W/2])
    cuboid([HookX3+W*2, H, W], rounding=R,
        edges="Y", except = [-1, 0, 1]);
    }

    }

}

rotate([90,0,0])
//iphone_3dprint();

iphone_mount();