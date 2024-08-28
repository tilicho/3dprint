include <BOSL2/std.scad>
include <BOSL2/screws.scad>

SIZE_X = 55;
SIZE_Y = 50;
SIZE_Z = 1.2;

HOLE_D = 3;

E = 0.4;
EE = 0.01;

HOLE_X = 50;
HOLE_Y = 45;


$fn = 50;

PORTS_DX = 5.8;
PORTS_SIZE_X = 16;
PORTS_Z = 13.8;
PORTS_Y = 20.2;

PORTS2_X = 7;//15.7;
PORTS2_Y = 13.5;
PORTS2_Z = PORTS_Z;

PORTS22_DX = 3.8;

PORTS22_X = 4.22;//8.63;
PORTS22_Y = PORTS2_Y;
PORTS22_Z = 9.88;


PORTS3_DX = 5.2;
PORTS3_X = 6.5;
PORTS3_Y = 6.2;
PORTS3_Z = 3;

PINS1_X = 5;
PINS1_Y = 33;
PINS1_Z = 8.7;
PINS1_DX = 0.4;
PINS1_DY = 10.5;

PINS2_X = 2.5;
PINS2_Y = PINS1_Y;
PINS2_Z = PINS1_Z;
PINS2_DX = 0.2;
PINS2_DY = PINS1_DY;

PINS3_X = 7.6;
PINS3_Y = 2.5;
PINS3_Z = PINS1_Z;
PINS3_DX = 7.3;


SD_X = 11.4+0.8;
SD_Y = 12.3+0.8;
SD_Z = 1.4+0.8;
SD_DX = 6.2;

module orangepi_base(show_base=true, 
    oversize_z=0.4, 
    show_back_pin=true,
    show_only_pins=false)
{
scale_k = 1 + 2*oversize_z / SIZE_X;
oversize = 0;

ports_size_x = PORTS_SIZE_X + oversize;
ports_y = PORTS_Y + oversize;
ports_z = PORTS_Z + oversize;

ports2_x = PORTS2_X + oversize;
ports2_y = PORTS2_Y + oversize;
ports2_z = PORTS2_Z + oversize;

ports22_x = PORTS22_X + oversize;
ports22_y = PORTS22_Y + oversize;
ports22_z = PORTS22_Z + oversize;

ports3_x = PORTS3_X + oversize;
ports3_y = PORTS3_Y + oversize;
ports3_z = PORTS3_Z + oversize;

sd_x = SD_X + oversize;
sd_y = SD_Y + oversize;
sd_z = SD_Z + oversize;

scale(scale_k)
diff()
{
cuboid([SIZE_X, SIZE_Y, SIZE_Z], rounding=2, edges="Z")
{
align(TOP)
{
if (!show_only_pins)
xflip()
translate([SIZE_X/2-ports_size_x/2-PORTS_DX,
    SIZE_Y/2-ports_y/2,0])
cuboid([ports_size_x, ports_y, ports_z])
align(LEFT+BACK)
{
translate([0,-ports2_y,0])
cuboid([ports2_x, ports2_y, ports_z])
align(LEFT+BACK)
{

translate([-PORTS22_DX,-ports22_y,-ports2_z/2+ports22_z/2])
cuboid([ports22_x, ports22_y, ports22_z])
align(LEFT+BACK)
    translate([-PORTS3_DX,-ports3_y,-ports22_z/2+ports3_z/2])
    cuboid([ports3_x, ports3_y, ports3_z]);
}

}

}
if (show_back_pin)
align(TOP+RIGHT)
{
translate([-PINS1_DX,-PINS1_Y/2+SIZE_Y/2-PINS1_DY,0])
cuboid([PINS1_X, PINS1_Y, PINS1_Z], anchor=BOTTOM, rounding=1, edges="Z");

}

if (show_back_pin)
align(TOP+LEFT)
{
translate([PINS2_DX,-PINS2_Y/2+SIZE_Y/2-PINS2_DY,0])
cuboid([PINS2_X, PINS2_Y, PINS2_Z], anchor=BOTTOM, rounding=1, edges="Z");

}
if (show_back_pin)
align(TOP+FRONT)
{
translate([SIZE_X/2-PINS3_X/2-PINS3_DX,0,0])
cuboid([PINS3_X, PINS3_Y, PINS3_Z], anchor=BOTTOM, rounding=1, edges="Z");
}

align(BOTTOM+FRONT)
{
translate([-SIZE_X/2+sd_x/2+SD_DX,0,0])
cuboid([sd_x, sd_y, sd_z], anchor=BOTTOM);
}

/*if (show_base)
align(BOTTOM)
{
color("red")
translate([0,SIZE_Y/2,-1.2])
rect([SIZE_X,SIZE_Y]);
}*/

}




tag("remove")
yflip_copy()
xflip_copy()
translate([HOLE_X/2, HOLE_Y/2, 0])
zcyl(d = HOLE_D, h = 5);

if (!show_base)
tag("remove")
cuboid([SIZE_X+EE, SIZE_Y+EE, SIZE_Z+EE]);
}



}


orangepi_base(show_only_pins=false);