include <BOSL2/std.scad>
include <BOSL2/screws.scad>
DX_ = 100;
DY_ = 71.4;
WALL = 9;

DX = DX_ + WALL;
DY = DY_ + WALL;

H = 7;
R = 5;
D = 5;
E = 0.1;
$fn = 100;


VholeLen = 5;
VholeD = 5;

module make_hole()
{
    translate([DY/2-WALL/2, DY/2-WALL/2, 0]) 
        cyl(l = H+E, d = 5);
}


module make_vhole()
{
    translate([DX/2-VholeLen/2,0,0])
        xcyl(l = VholeLen+E, d = VholeD);
}

module frame_part1()
{
    diff()
    rect_tube(size=[DX, DY], wall=WALL, 
        rounding=R, irounding=R, h=H, center=true)
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
}

module frame1()
{
    difference()
    {
        frame_part1();

        make_vhole();

        xflip()
            make_vhole();
            
    }
}


frame1();