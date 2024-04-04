include <BOSL2/std.scad>

R = 12.3;
WALL=2.4;
RO = R + WALL;
$fn=40;
CUT=false;
LEN=60;

module handle()
{

diff()
cyl(h=LEN, d=RO, texture="diamonds", tex_size=[6,6], center=true)
{
up(LEN/2)
chamfer_cylinder_mask(d=RO, chamfer=1);

attach(DOWN)
chamfer_cylinder_mask(d=RO, chamfer=1);

tag("remove") up(WALL) cyl(h=LEN-WALL, d=R, center=true);
};

}

module perform_cut()
{
    if (CUT)
        top_half(z=20) children();
    else children();
}

perform_cut() handle();