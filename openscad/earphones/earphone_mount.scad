include <BOSL2/std.scad>
use <../screws/screw_mount.scad>

TABLE_H = 17.4;
TABLE_X = 40;
TABLE_Y = 30;
E = 0.1;
R = 3;
$fn = 50;
W = 5;

HOOK_X = 100;

difference()
{
cuboid([TABLE_X, TABLE_Y, TABLE_H+W*2],
    rounding=R,
    edges = "Z",
    except=RIGHT);

cuboid([TABLE_X+E, TABLE_Y+E, TABLE_H],
    rounding=R,
    edges = "Z",
    except=BACK);
    
translate([0,0,-TABLE_H/2])
hole(W+E*2, anchor=TOP);
    
}

translate([TABLE_X/2-W/2,0,0])
cuboid([W, TABLE_Y, TABLE_H+W*2], 
    //rounding=0.5,
    //edges="Z",
    anchor=CENTER)
align(LEFT)
translate([W+HOOK_X/2,0,0])
{
dy = TABLE_H+W;
//#cuboid([HOOK_X, TABLE_Y, W], anchor=CENTER);
translate([0,0,-W+1])
rotate([0,90,0])
prismoid(
    [dy,TABLE_Y],[W,TABLE_Y],
    shift=[-dy/2,0],
    h=HOOK_X)
attach(TOP)  
translate([-W,0,-W/2])
cuboid([W*3,TABLE_Y,W]);
}