include <BOSL2/std.scad>

Wall = 1.2;
L = 101.7 + 0.8; //30 + 2*1.8 + 0.8;//101.7;
H = 5;//10;
R = 1;

$fn=50;

module cub(dxy)
{
cuboid([L + dxy, L + dxy, H+Wall], 
        rounding=R, 
        edges="Z"
        );
}


difference()
{
    cub(2*Wall);
    
    translate([0,0,Wall])
    cub(0);
}