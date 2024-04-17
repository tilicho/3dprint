include <BOSL2/std.scad>
include <BOSL2/screws.scad>
DX = 100;
DY = 71.4;
WALL = 10;
H = 5;
R = 5;
D = 5;
E = 0.1;
$fn = 100;

module make_hole()
{
    translate([DY/2-WALL/2, DY/2-WALL/2, 0]) 
        cyl(l = H+E, d = 5);
}

diff()
rect_tube(size=[DX, DY], wall=WALL, rounding=R, h=H)
{
tag("remove") 
    make_hole();
       
tag("remove") 
    xflip()
        make_hole();

tag("remove")
    yflip()
    {
        make_hole();
        xflip()
            make_hole();
    }
       
}
//screw_hole("1/4-20,.5",head="socket",counterbore=5,anchor=TOP);