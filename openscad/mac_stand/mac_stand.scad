include <BOSL2/std.scad>

W = 4.8;

MAC_W = 19 + 0.8;

DH = 0;

H_WALL = 50;
H_HOR = 40;

L1 = 170;
L2 = 0;

z =  H_WALL + DH + W;

diff()
{
cuboid([L1 + L2, MAC_W + 2 * W, z])
{
align(FRONT)
{
    z2 = DH+W;    
    translate([0,0,-z/2+z2/2])
    cuboid([L1+L2,H_HOR,DH+W]);
}
}

#tag("remove")
translate([0,0,(W+DH)/2])
cuboid([L1 + L2, MAC_W, H_WALL]);
}