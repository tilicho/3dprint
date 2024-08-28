include <BOSL2/std.scad>
include <BOSL2/screws.scad>

DX = 41.5;
DY = 41.5;
DZ = 10;
W = 5;

difference()
{
cuboid([DX+2*W, DY+2*W, DZ], rounding=4, edges="Z", $fn=50);
cuboid([DX, DY, DZ+W], rounding=0, edges="Z", $fn=50);
}