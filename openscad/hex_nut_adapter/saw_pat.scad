include <BOSL2/std.scad>
use <../screws/screw_mount.scad>

DX = 20.4;
H = 13;
R = 5;
W = 10;
E =0.1;
$fn=50;

difference()
{
    cuboid([DX+W*2, DX+W*2, H], rounding=R, edges="Z");
    translate([0, DX/2, 0])
    cuboid([DX, DX*2, H+E], rounding=0, edges="Z");

    
    xflip_copy()
    rotate([0,0,90])
    translate([0, -DX+E, 0])
    rotate([90,0,0])
    hole(W+E*2, anchor=TOP);
}